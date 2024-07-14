#include <linux/sched.h>
#include <linux/in.h>


#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>


SEC("kprobe/sys_bind")
int bpf_prog(struct pt_regs *ctx) {
        struct sockaddr_in* addr = (struct sockaddr_in *)PT_REGS_PARM2(ctx);

        if (ntohs(addr->sin_port) == 8080) {
                bpf_printk("Access denied! pid: %d, port: %d\n",
                        bpf_get_current_pid_tgid()>>32, ntohs(addr->sin_port));
		return -1;
        }

        return 0;
}

char _license[] SEC("license") = "GPL";
