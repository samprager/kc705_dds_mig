#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <netinet/ip.h>
#include <netinet/in.h>
#include <netinet/udp.h>
#include <net/if.h>
#include <netinet/if_ether.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <pcap.h>

#define WRITE_LIM 1000
#define PKT_SIZE 496
#define HEADER_SIZE 16
#define SUB_PKT_SIZE 64 // 64 bytes or 512 bits

/* We've included the UDP header struct for your ease of customization.
 * For your protocol, you might want to look at netinet/tcp.h for hints
 * on how to deal with single bits or fields that are smaller than a byte
 * in length.
 *
 * Per RFC 768, September, 1981.
 */
struct UDP_hdr {
 u_short	uh_sport;		/* source port */
 u_short	uh_dport;		/* destination port */
 u_short	uh_ulen;		/* datagram length */
 u_short	uh_sum;			/* datagram checksum */
};
/* Some helper functions, which we define at the end of this file. */

/* Returns a string representation of a timestamp. */
const char *timestamp_string(struct timeval ts);

/* Report a problem with dumping the packet with the given timestamp. */
void problem_pkt(struct timeval ts, const char *reason);

/* Report the specific problem of a packet being too short. */
void too_short(struct timeval ts, const char *truncated_hdr);

/* dump_UDP_packet()
*
* This routine parses a packet, expecting Ethernet, IP, and UDP headers.
* It extracts the UDP source and destination port numbers along with the UDP
* packet length by casting structs over a pointer that we move through
* the packet.  We can do this sort of casting safely because libpcap
* guarantees that the pointer will be aligned.
*
* The "ts" argument is the timestamp associated with the packet.
*
* Note that "capture_len" is the length of the packet *as captured by the
* tracing program*, and thus might be less than the full length of the
* packet.  However, the packet pointer only holds that much data, so
* we have to be careful not to read beyond it.
*/
void dump_UDP_packet(const unsigned char *packet, struct timeval ts,unsigned int capture_len)
{
  struct ip *ip;
  struct UDP_hdr *udp;
  unsigned int IP_header_length;

  /* For simplicity, we assume Ethernet encapsulation. */

  if (capture_len < sizeof(struct ether_header))
  {
    /* We didn't even capture a full Ethernet header, so we
    * can't analyze this any further.
    */
    too_short(ts, "Ethernet header");
    return;
  }

  /* Skip over the Ethernet header. */
  packet += sizeof(struct ether_header);
  capture_len -= sizeof(struct ether_header);

  if (capture_len < sizeof(struct ip))
  { /* Didn't capture a full IP header */
    too_short(ts, "IP header");
    return;
  }

  ip = (struct ip*) packet;
  IP_header_length = ip->ip_hl * 4;	/* ip_hl is in 4-byte words */

  if (capture_len < IP_header_length)
  { /* didn't capture the full IP header including options */
  too_short(ts, "IP header with options");
  return;
  }

  if (ip->ip_p != IPPROTO_UDP)
  {
    problem_pkt(ts, "non-UDP packet");
    return;
  }

  /* Skip over the IP header to get to the UDP header. */
  packet += IP_header_length;
  capture_len -= IP_header_length;

  if (capture_len < sizeof(struct UDP_hdr))
  {
    too_short(ts, "UDP header");
    return;
  }

  udp = (struct UDP_hdr*) packet;

  printf("%s UDP src_port=%d dst_port=%d length=%d\n",
  timestamp_string(ts),
  ntohs(udp->uh_sport),
  ntohs(udp->uh_dport),
  ntohs(udp->uh_ulen));
}

int decodePacket(uint32_t **dataIQ, uint32_t **counter,unsigned char *packet_data,int size, int numpkts)
{
  int i,j,s_index,e_index,sq_size32,start_found;
  int counter_offset;
  uint32_t temp0,temp1;
  uint32_t u_cval0,l_cval0,u_cval1,l_cval1;

  u_cval0 = *((uint32_t*)packet_data);
  l_cval0 = *(((uint32_t*)packet_data)+1);
  u_cval1 = *(((uint32_t*)packet_data)+2);
  l_cval1 = *(((uint32_t*)packet_data)+3);

// Determine whether counter is in upper or lower 32 bits of 64b word
  if ((u_cval0 == u_cval1+1)||(u_cval1 == u_cval0+15)) {
    counter_offset = 0;
  } else if ((l_cval0 == l_cval1+1)||(l_cval1 == l_cval0+15)) {
    counter_offset = 1;
  } else {
    return -1;
  }

// find start of first 512 bit sub-packet
  s_index = 0;
  start_found = 0;
  while (start_found == 0){
    if(s_index == 16){
      return -1;
    }
    temp0 = *(((uint32_t*)packet_data)+counter_offset+s_index);
    temp1 = *(((uint32_t*)packet_data)+counter_offset+s_index+2);
    if (temp0 != temp1+1){
      start_found = 1;
    }
    s_index += 2;
  }
  s_index = s_index%16;

  e_index = ((numpkts*size)/4 - s_index)%16;

  sq_size32 = ((numpkts*size)/4 - s_index - e_index)/2;

  *dataIQ = (uint32_t *)malloc(sq_size32*sizeof(uint32_t));
  *counter = (uint32_t *)malloc(sq_size32*sizeof(uint32_t));

//reverse order of 32 bit words for each 512 bit sub-packet
  for (i=0;i<sq_size32;i+=8){
    for (j=0;j<8;j++){
      memcpy(*counter+i+j,((uint32_t*)packet_data)+2*i+s_index+counter_offset+14-2*j,sizeof(uint32_t));
      memcpy(*dataIQ+i+j,((uint32_t*)packet_data)+2*i+s_index+1-counter_offset+14-2*j,sizeof(uint32_t));
    }
  }
  return sq_size32;

}

int main(int argc, char *argv[])
{
  pcap_t *pcap;
  FILE *fp,*fp_c,*fp_iq;
  const unsigned char *packet;
  char errbuf[PCAP_ERRBUF_SIZE];
  struct pcap_pkthdr header;
  int mode_select;    // 0: dump udp packet, 1: dump data at offset
  int offset = HEADER_SIZE;
  int trim = 0;
  char *filename,*filenameC,*filenameIQ;
  unsigned char *packet_data;
  uint32_t *counter = NULL;
  uint32_t *dataIQ = NULL;
  int count,wcount,datasize,p_datasize;

  /* Skip over the program name. */
  ++argv; --argc;

  /* We expect exactly one argument, the name of the file to dump. */
  if ( argc < 1 )
  {
    fprintf(stderr, "program requires one argument, the trace file to dump\n");
    exit(1);
  }

  if (argc < 2){
    mode_select = 0;
  } else if (argc<3) {
    mode_select = 1;
    filename = argv[1];
    printf("%s",argv[1]);
  }  else if (argc<4){
    mode_select = 2;
    filenameC = argv[1];
    filenameIQ = argv[2];
  } else {
    mode_select = 3;
    filename = argv[1];
    filenameC = argv[2];
    filenameIQ = argv[3];
  }

  pcap = pcap_open_offline(argv[0], errbuf);
  if (pcap == NULL) {
    fprintf(stderr, "error reading pcap file: %s\n", errbuf);
    exit(1);
  }

  /* Now just loop through extracting packets as long as we have
  * some to read.
  */
  if(mode_select==0){
    while ((packet = pcap_next(pcap, &header)) != NULL){
      dump_UDP_packet(packet, header.ts, header.caplen);
    }
  } else {
    count = 0;
    wcount = 0;
    p_datasize = PKT_SIZE - offset - trim;
    packet_data = (unsigned char *)malloc(WRITE_LIM*p_datasize*sizeof(unsigned char));
    while ((count<WRITE_LIM)&&((packet = pcap_next(pcap, &header)) != NULL)){
      if (header.caplen==PKT_SIZE){
        memcpy (packet_data+wcount*p_datasize,packet+offset,header.caplen-offset-trim);
        wcount++;
      }
      count++;
    }
    if ((mode_select == 1)||(mode_select == 3)){
      fp = fopen(filename, "wb" );
      fwrite (packet_data,sizeof(char),p_datasize*wcount,fp);
      fclose(fp);

      printf("Wrote %i out of %i packets \n",wcount,count);
    }

    if ((mode_select == 2)||(mode_select == 3)){
      datasize = decodePacket(&dataIQ,&counter,packet_data,p_datasize,wcount);
      if (datasize == -1) {
        fprintf(stderr, "Decode Packet failed. Returned: %i\n" ,datasize);
        exit(1);
      }

      printf("Decoded %i out of %i packets \n",wcount,count);
      printf("datasize: %i, counter[0]: %u, counter[end-1]: %u \n",datasize,counter[0],counter[datasize-1]);

      fp_c = fopen(filenameC, "wb" );
      fp_iq = fopen(filenameIQ, "wb" );

      fwrite (counter,sizeof(uint32_t),datasize,fp_c);
      fwrite (dataIQ,sizeof(uint32_t),datasize,fp_iq);

      fclose(fp_c);
      fclose(fp_iq);

      free(counter);
      free(dataIQ);
    }

    free(packet_data);
  }
  // terminate
  return 0;
}

/* Note, this routine returns a pointer into a static buffer, and
* so each call overwrites the value returned by the previous call.
*/
const char *timestamp_string(struct timeval ts)
{
  static char timestamp_string_buf[256];

  sprintf(timestamp_string_buf, "%d.%06d",
  (int) ts.tv_sec, (int) ts.tv_usec);

  return timestamp_string_buf;
}

void problem_pkt(struct timeval ts, const char *reason)
{
  fprintf(stderr, "%s: %s\n", timestamp_string(ts), reason);
}

void too_short(struct timeval ts, const char *truncated_hdr)
{
  fprintf(stderr, "packet with timestamp %s is truncated and lacks a full %s\n",
  timestamp_string(ts), truncated_hdr);
}
