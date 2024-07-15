#include <linux/sched.h>
#include <linux/ptrace.h>
#include <linux/in.h>
#include <linux/bpf.h>

#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>
#include <bpf/bpf_tracing.h>


SEC("kprobe/__x64_sys_bind")
int bpf_prog(struct pt_regs *ctx) {
        struct sockaddr_in addr;
	
	bpf_probe_read_kernel(&addr, sizeof(addr), (void *)PT_REGS_PARM2(ctx));

        if (bpf_ntohs(addr.sin_port) == 8080) {
                bpf_printk("Access denied! pid: %d, port: %d\n",
                        bpf_get_current_pid_tgid()>>32, bpf_ntohs(addr.sin_port));
		return -1;
        }

        return 0;
}

char _license[] SEC("license") = "GPL";
