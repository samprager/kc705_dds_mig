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
#include <pthread.h>
#include <stdint.h>
#include <time.h>

#define WRITE_LIM 100
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

struct arg_struct{
  void *filename;
  void *devname;
  void *dimensions;
  void *mutex;
  void *buffer;
  void *newdata;
  void *threadcontrol;
};

// struct arg_struct{
//   char *filename;
//   char *devname;
//   char *dimensions;
//   pthread_mutex_t *mutex;
//   uint32_t **buffer;
//   int *threadcontrol;
// };

/* Some helper functions, which we define at the end of this file. */

void pcap_fatal(const char *failed_in, const char *errbuf) {
    printf("Fatal Error in %s: %s\n", failed_in, errbuf);
    exit(1);
}

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

void *listenThread(void *args){
  int i;
  int numbufs,len,offset,trim;
  int threadexit,wcount,count;
  int *dim, *threadcontrol, *newdata;
  struct arg_struct *arguments = (struct arg_struct *)args;
  dim = (int *)arguments->dimensions;

  struct pcap_pkthdr header;
  const u_char *packet;
  char errbuf[PCAP_ERRBUF_SIZE];
  char *device;
  pcap_t *pcap_handle;

  pthread_mutex_t *mutex;

  numbufs = dim[0];
  len = dim[1];
  offset = dim[2];
  trim = dim[3];
  threadcontrol = (int *)arguments->threadcontrol;

  newdata = (int *)arguments->newdata;

  mutex = (pthread_mutex_t *)arguments->mutex;

  threadexit = 0;
  i = 0;
  count = 0;
  wcount = 0;


  device = (char *)arguments->devname;
  if(device == NULL)
      pcap_fatal("pcap_lookupdev", errbuf);

  printf("Sniffing on device %s\n", device);

  pcap_handle = pcap_open_live(device, 4096, 1, 1000, errbuf);
  if(pcap_handle == NULL)
      pcap_fatal("pcap_open_live", errbuf);

  while (threadexit==0){
    if ((packet = pcap_next(pcap_handle, &header)) != NULL){
      if (header.caplen==len){
        pthread_mutex_lock(&mutex[i]);
        // while (newdata[i] ==1) {
        //   //printf("data %i locked \n",i);
        //   pthread_mutex_unlock(&mutex[i]);
        //   usleep(10);
        //   pthread_mutex_lock(&mutex[i]);
        // }
        memcpy(*((unsigned char **)arguments->buffer + i),packet+offset,header.caplen-offset-trim);
        // printf("%u ", *(*((uint32_t**)arguments->buffer + i)));
        // printf(" %u ", *(*((uint32_t**)arguments->buffer + i)+1));
        // printf(" %u ", *(*((uint32_t**)arguments->buffer + i)+2));
        // printf(" %u\n", *(*((uint32_t**)arguments->buffer + i)+3));
        newdata[i] = 1;
        pthread_mutex_unlock(&mutex[i]);
        i = (i+1)%numbufs;
        wcount++;
        threadcontrol[2] = wcount;
      }
      count++;
      threadcontrol[3] = count;
    } else {
      //printf("NULL pacap handle\n");
      usleep(1);
    }
    threadexit = threadcontrol[0];
  }
  return NULL;
}
void *writeThread(void *args){
  int i;
  FILE *fp;
  int numbufs,len, offset, trim;
  int writecount,threadexit, writelim;
  int *dim, *threadcontrol, *newdata;
  char *filename;
  struct arg_struct *arguments = (struct arg_struct *)args;
  filename = (char *)arguments->filename;
  dim = (int *)arguments->dimensions;
  newdata = (int *)arguments->newdata;

  numbufs = dim[0];
  len = dim[1];
  offset = dim[2];
  trim = dim[3];
  threadcontrol = (int *)arguments->threadcontrol;
  pthread_mutex_t *mutex;
  mutex = (pthread_mutex_t *)arguments->mutex;
  printf("Write Thread with file: %s\n",filename);


  fp = fopen(filename,"wb");

  writecount = 0;
  writelim = threadcontrol[1];
  threadexit = 0;

  i = 0;
  //for(i=0;i<numbufs;i++) {
  while((threadexit==0)&&(writecount<writelim)){
      pthread_mutex_lock(&mutex[i]);
      //pbuffer[i] = *((unsigned char **)arguments->arg2 + i);

      // The following three statements are equivalent:

      //fwrite(pbuffer[i],sizeof(char),4*len,out);
      //fwrite(&pbuffer[i][0],sizeof(char),4*len,out);
      while (newdata[i]==0){
        //printf("write data %i locked \n",i);
        pthread_mutex_unlock(&mutex[i]);
        usleep(1);
        pthread_mutex_lock(&mutex[i]);
      }
      fwrite( *((unsigned char **)arguments->buffer + i),sizeof(char),len-offset-trim,fp);
      newdata[i] = 0;
      pthread_mutex_unlock(&mutex[i]);
      writecount++;
      threadexit = threadcontrol[0];
      threadcontrol[2] = writecount;
      i = (i+1)%numbufs;
  }

  fclose(fp);
  return NULL;

}

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

void getNetworkDevices(){
  char errbuf[PCAP_ERRBUF_SIZE];
  pcap_if_t *alldevsp, *currdevp;
  pcap_addr_t *curraddr;
  sa_family_t currfamily;
  pcap_findalldevs(&alldevsp,errbuf);
  currdevp = alldevsp;

  while((currdevp)!=NULL){
      printf("found dev %s\t", currdevp->name);
      printf("desc: %s\t",currdevp->description);
      //printf("addr: %s\t",curraddr->addr->sa_data);
      printf("flag: %u\n",currdevp->flags);


      curraddr = currdevp->addresses;
      while((curraddr)!=NULL){
          //printf("\t%s\taddr:", currdevp->name);
          currfamily = curraddr->addr->sa_family;

          if(currfamily == AF_INET){
              struct sockaddr_in *saddress_in = (struct sockaddr_in *)curraddr->addr;
              char ipAddress[INET_ADDRSTRLEN];
              inet_ntop(currfamily, &(saddress_in->sin_addr), ipAddress, INET_ADDRSTRLEN);
              printf("\tipv4:   %s",ipAddress);
          }
          else if(currfamily == AF_INET6){
              struct sockaddr_in6 *saddress_in = (struct sockaddr_in6 *)curraddr->addr;
              char ipAddress[INET6_ADDRSTRLEN];
              inet_ntop(currfamily, &(saddress_in->sin6_addr), ipAddress, INET6_ADDRSTRLEN);
              printf("\tipv6:   %s",ipAddress);
          }
          else if(currfamily == AF_LINK){
              printf("\tether:  ");
              for(int i=9;i<15;i++){
                  printf("%02x",(unsigned char) *(curraddr->addr->sa_data+i));
                  if(i<14) printf(":");
              }
          }
          //printf("\tfamily: %u\n",(unsigned int)currfamily);
          printf("\n");
          curraddr = curraddr->next;
      }

      currdevp = currdevp->next;
  }
  currdevp = alldevsp;
  // terminate
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
  char *filename,*device;
  unsigned char *packet_data;
  uint32_t *counter = NULL;
  uint32_t *dataIQ = NULL;
  int count,wcount,datasize,p_datasize;

  int i,j,err;
  int numbufs = 1000;    // Number of row buffers
  int numextbufs = 10;    // Number of row external buffers

  int len8 = PKT_SIZE;   // buffer size in bytes
  int len32 = len8/4;
  int numthreads = 2;
  int dim[4];
  int **threadctrl;
  int *newdata;

    //uint32_t buffer[numbufs][len];
  unsigned char ** pbuffer;
  unsigned char ** pextbuf;
  struct arg_struct args[numthreads];


pthread_mutex_t *mutex;
pthread_t *threads;

  clock_t t,end,overhead;

  /* Skip over the program name. */
  ++argv; --argc;

  filename = argv[1];
  if (argc < 1){
    filename = "outdata.bin";
    device = "en4";
  } else if (argc<2) {
    filename = argv[0];
    device = "en4";
  }  else {
    filename = argv[0];
    device = argv[1];
  }


  dim[0] = numbufs;
  dim[1] = len8;

  dim[2] = offset;
  dim[3] = trim;

  overhead = clock();
  overhead = clock()-overhead;
  t = clock();

  //for (i=0;i<numbufs;i++) pbuffer[i] = (unsigned char*)b1[i];
  //for (i=0;i<numbufs;i++) pbuffer[i] = (unsigned char*)calloc(len*4,sizeof(unsigned char));
  pbuffer = (unsigned char **)malloc(numbufs*sizeof(unsigned char *));
  pextbuf = (unsigned char **)malloc(numextbufs*sizeof(unsigned char *));
  threadctrl = (int**)malloc(numthreads*sizeof(int *));

  for (i=0;i<numbufs;i++) pbuffer[i] = (unsigned char*)malloc(len8*sizeof(unsigned char));
  for (i=0;i<numextbufs;i++) pextbuf[i] = (unsigned char*)malloc(len8*sizeof(unsigned char));
  for(i=0;i<numthreads;i++) threadctrl[i] = (int *)malloc(4*sizeof(int));

  for(i=0;i<numthreads;i++){
    threadctrl[i][0] = 0;
    threadctrl[i][1] = WRITE_LIM;
    threadctrl[i][2] = 0;
    threadctrl[i][3] = 0;
  }
  newdata = (int *)malloc(numbufs*sizeof(int));
  for (i=0;i<numbufs;i++) newdata[i] = 0;

 threads = malloc(numthreads*sizeof(*threads));

 // mutex = calloc(numbufs,sizeof(*mutex));
 mutex = malloc(numbufs*sizeof(*mutex));

  for (i=0;i<numbufs;i++){
      if(pthread_mutex_init(&mutex[i],NULL)!=0){
          printf("\nMutex %i init error",i);
          return 1;
      }
  }
  for(i=0;i<numthreads;i++){
      args[i].mutex = (void *)mutex;
      args[i].dimensions = (void *)dim;
      args[i].threadcontrol = (void *)threadctrl[i];
      args[i].buffer = (void *)pbuffer;
      args[i].devname = (void *)device;
      args[i].filename = (void *)filename;
      args[i].newdata = (void *)newdata;
  }

  getNetworkDevices();

 // Create Read Threads

  err = pthread_create(&threads[0],NULL,listenThread,(void *)&args[0]);
  if(err != 0) {
      printf("\nError initializing Read thread: %i\n",err);
      return 1;
  }
  usleep(10);

  // Create Write Thread
  //err = pthread_create(&threads[2],NULL,writethread,(void *)&args[2]);
  err = pthread_create(&threads[1],NULL,writeThread,(void *)&args[1]);
  if(err != 0) {
      printf("\nError initializing Write thread: %i\n",err);
      return 1;
  }
  usleep(1);

  usleep(100);
  while(threadctrl[1][2] < WRITE_LIM){
    printf("read: %i/%i, written: %i \n",threadctrl[0][2],threadctrl[0][3],threadctrl[1][2]);
    usleep(1000000);
  }
  printf("read: %i/%i, written: %i \n",threadctrl[0][2],threadctrl[0][3],threadctrl[1][2]);

  threadctrl[0][0] = 1;
  err = pthread_join(threads[0],NULL);
  if(err != 0) {
      printf("\nError joining Read thread: %i\n",err);
      //return 1;
  }

  threadctrl[1][0] = 1;
  err = pthread_join(threads[1],NULL);
  if(err != 0) {
      printf("\nError joining Write thread: %i\n",err);
      //return 1;
  }

  // plot data with gnuplot
  //system("gnuplot -p 'plotdata.gp'");


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
