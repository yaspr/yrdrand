#include <stdio.h>

#include "types.h"
#include "yrdrand.h"

void print_hex(u8 *ptr, u64 n_bytes)
{
  for (u64 i = 0; i < n_bytes; i++)
    printf("%02x", ptr[i]);
}

void print_rand()
{
  const u16 n_rands = (10 + yrdrand16() % 101) % 11;

  printf ("--> Generating %u random numbers\n", n_rands);
  
  for (u64 i = 0; i < n_rands; i++)
    {
      printf("%llu:\n", i);
      
      u16 r16 = yrdrand16();
      printf("\t16-bit: 0x%04x\n", r16);

      u32 r32 = yrdrand32();
      printf("\t32-bit: 0x%08x\n", r32);
  
      u64 r64 = yrdrand64();
      printf("\t64-bit: 0x%016llx\n", r64);
    }
}

void ygetrandom(u8 *ptr, u64 n_bytes)
{
  u64 *p = (u64 *)ptr;
  const u64 m = n_bytes & 3;
  const u64 n = n_bytes - m;
  
  for (u64 i = 0; i < n >> 3; i++)
    p[i] = yrdrand64();

  for (u64 i = n; i < n_bytes; i++)
    ptr[i] = (u8)yrdrand16();
}

int main (void)
{
  if (yrdseed_check())
    printf("--> Intel RDSEED Available\n");
  else
    printf("--> Intel RDSEED Unavailable\n");
  
  if (yrdrand_check())
    {
      printf("--> Intel RDRAND Available\n");
      print_rand();
    }
  else
    printf("--> Intel RDRAND Unavailable\n");  

  u8 buffer1[16];
  u8 buffer2[32];
  u8 buffer3[64];
  
  ygetrandom(buffer1, 16);
  ygetrandom(buffer2, 32);
  ygetrandom(buffer3, 64);

  printf("\n--> Random buffer1: ");
  print_hex(buffer1, 16);
  printf("\n");

  printf("--> Random buffer2: ");
  print_hex(buffer2, 32);
  printf("\n");

  printf("--> Random buffer3: ");
  print_hex(buffer3, 64);
  printf("\n");

  return 0;
}
