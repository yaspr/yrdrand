/*
 * Reference: https://software.intel.com/en-us/articles/intel-digital-random-number-generator-drng-software-implementation-guide
 *    Most important sections:	
 *      Section 5.1: Determining Processor Support for RDRAND and RDSEED
 *	Section 5.2: Using RDRAND to Obtain Random Values
 */

.global yrdrand_check
.global yrdseed_check
.global yrdrand16
.global yrdrand32
.global yrdrand64

//Check if RDSEED is available on CPU
yrdseed_check:
   pushq %rbp
   movq  %rsp, %rbp

   movq  %rbx, %rsi   			# Save RBX before CPUID 

   movq  $7,   %rax   			# EAX=7 & ECX=0 for extended CPU features
   xorq  %rcx, %rcx
   cpuid

   mov   $0x40000, %r8d 		# Check if 18th bit of EBX (RDSEED bit) is set
   test  %ebx, %r8d			
   jz    yrdseed_check_unavailable    	# RDSEED unavailable on CPU

   movq  $1,   %rax			# Return 1 (Available) 
   jmp   yrdseed_check_exit

yrdseed_check_unavailable:
   xorq  %rax, %rax			# Return 0 (Unavailable)

yrdseed_check_exit:
   movq  %rsi, %rbx   			# Restore RBX
   popq  %rbp
   ret

//Check if RDRAND is available on CPU
yrdrand_check:
   pushq %rbp
   movq  %rsp, %rbp

   movq  %rbx, %rsi   			# Save RBX before CPUID

   movq  $1,   %rax			# EAX=1 for CPU info and feature flags
   cpuid

   mov   $0x40000000, %r8d 		# Check if 30th bit of ECX (RDRAND bit) is set
   test  %ecx, %r8d
   jz    yrdrand_check_unavailable    	# RDRAND unavailable on CPU

   movq  $1,   %rax			# Return 1 (Available)
   jmp   yrdrand_check_exit

yrdrand_check_unavailable:
   xorq  %rax, %rax			# Return 0 (Unavailable)

yrdrand_check_exit:
   movq  %rsi, %rbx   			# Restore RBX
   popq  %rbp
   retq

//RDRAND 16-bit
yrdrand16:
   pushq %rbp
   movq  %rsp, %rbp

repeat_if_fail16:
   rdrand %ax
   pause           			# Thread safety
   jnc repeat_if_fail16     		# The CF is the sole indicator of the success or failure of the RDRAND instruction

   popq  %rbp
   retq

//RDRAND 32-bit
yrdrand32:
   pushq %rbp
   movq  %rsp, %rbp

repeat_if_fail32:
   rdrand %eax
   pause           			# Thread safety
   jnc repeat_if_fail32			# The CF is the sole indicator of the success or failure of the RDRAND instruction

   popq  %rbp
   retq

//RDRAND 64-bit
yrdrand64:
   pushq %rbp
   movq  %rsp, %rbp

repeat_if_fail64:
   rdrand %rax
   pause           			# Thread safety
   jnc repeat_if_fail64     		# The CF is the sole indicator of the success or failure of the RDRAND instruction

   popq  %rbp
   retq
