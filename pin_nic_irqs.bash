#!/usr/bin/bash

# root@hp0:/home/das# lspci  | grep Ethernet | grep Intel
# 01:00.0 Ethernet controller: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2 (rev 01)
# 01:00.1 Ethernet controller: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2 (rev 01)

# das@hp0:~$ grep -E "(CPU|enp1s)" /proc/interrupts
#             CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7
#   67:          0          0          0          0          0    2721594          0          0  IR-PCI-MSIX-0000:01:00.0    0-edge      enp1s0f0-TxRx-0
#   68:          0          0          0          0          0          0    2862988          0  IR-PCI-MSIX-0000:01:00.0    1-edge      enp1s0f0-TxRx-1
#   69:          0          0          0          0          0          0          0    2761692  IR-PCI-MSIX-0000:01:00.0    2-edge      enp1s0f0-TxRx-2
#   70:    3055414          0          0          0          0          0          0          0  IR-PCI-MSIX-0000:01:00.0    3-edge      enp1s0f0-TxRx-3
#   71:          0    2737671          0          0          0          0          0          0  IR-PCI-MSIX-0000:01:00.0    4-edge      enp1s0f0-TxRx-4
#   72:          0          0    2839222          0          0          0          0          0  IR-PCI-MSIX-0000:01:00.0    5-edge      enp1s0f0-TxRx-5
#   73:          0          0          0    2773646          0          0          0          0  IR-PCI-MSIX-0000:01:00.0    6-edge      enp1s0f0-TxRx-6
#   74:          0          0          0          0    2750096          0          0          0  IR-PCI-MSIX-0000:01:00.0    7-edge      enp1s0f0-TxRx-7
#   75:          0          0          0          0          0          2          0          0  IR-PCI-MSIX-0000:01:00.0    8-edge      enp1s0f0
#   77:          0          0          0          0          0          0    3039910          0  IR-PCI-MSIX-0000:01:00.1    0-edge      enp1s0f1-TxRx-0
#   78:          0          0          0          0          0          0          0    2676661  IR-PCI-MSIX-0000:01:00.1    1-edge      enp1s0f1-TxRx-1
#   79:    3019034          0          0          0          0          0          0          0  IR-PCI-MSIX-0000:01:00.1    2-edge      enp1s0f1-TxRx-2
#   80:          0    2735311          0          0          0          0          0          0  IR-PCI-MSIX-0000:01:00.1    3-edge      enp1s0f1-TxRx-3
#   81:          0          0    3236724          0          0          0          0          0  IR-PCI-MSIX-0000:01:00.1    4-edge      enp1s0f1-TxRx-4
#   82:          0          0          0    2773971          0          0          0          0  IR-PCI-MSIX-0000:01:00.1    5-edge      enp1s0f1-TxRx-5
#   83:          0          0          0          0    3078869          0          0          0  IR-PCI-MSIX-0000:01:00.1    6-edge      enp1s0f1-TxRx-6
#   84:          0          0          0          0          0    2842023          0          0  IR-PCI-MSIX-0000:01:00.1    7-edge      enp1s0f1-TxRx-7
#   85:          0          0          0          0          0          0          4          0  IR-PCI-MSIX-0000:01:00.1    8-edge      enp1s0f1

# das@hp0:~$ cat /proc/irq/67/smp_affinity
# 00ff

# https://www.kernel.org/doc/html/latest/core-api/irq/irq-affinity.html

# das@t:~/Downloads$ cat pin_nic_irqs.bash
# #!/usr/bin/bash

echo grep -E "(CPU|enp1s)" /proc/interrupts
grep -E "(CPU|enp1s)" /proc/interrupts

for i in {67..85}
do
  echo "Loop:" $i
  # echo "echo 00f0 > /proc/irq/${i}/smp_affinity"
  # echo 00f0 > /proc/irq/"${i}"/smp_affinity
  echo "echo 0-3 > /proc/irq/"${i}"/smp_affinity_list"
  echo 0-3 > /proc/irq/"${i}"/smp_affinity_list
  echo "cat /proc/irq/"${i}"/smp_affinity"
  cat /proc/irq/"${i}"/smp_affinity
done

echo grep -E "(CPU|enp1s)" /proc/interrupts
grep -E "(CPU|enp1s)" /proc/interrupts
