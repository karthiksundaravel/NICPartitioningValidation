#!/usr/bin/bash

yum install -y openvswitch
export socket_mem="1024,1024"
export pmd_cpus="2,12,26,36"
export host_cpus="0,24"
function get_mask()
{
  local list=$1
  local mask=0
  declare -a bm
  max_idx=0
  for core in $(echo $list | sed 's/,/ /g')
  do
      index=$(($core/32))
      bm[$index]=0
      if [ $max_idx -lt $index ]; then
         max_idx=$(($index))
      fi
  done
  for ((i=$max_idx;i>=0;i--));
  do
      bm[$i]=0
  done
  for core in $(echo $list | sed 's/,/ /g')
  do
      index=$(($core/32))
      temp=$((1<<$(($core % 32))))
      bm[$index]=$((${bm[$index]} | $temp))
  done

  printf -v mask "%x" "${bm[$max_idx]}"
  for ((i=$max_idx-1;i>=0;i--));
  do
      printf -v hex "%08x" "${bm[$i]}"
      mask+=$hex
  done
  printf "%s" "$mask"
}
pmd_cpu_mask=$( get_mask $pmd_cpus )
host_cpu_mask=$( get_mask $host_cpus )
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem=$socket_mem
ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask=$pmd_cpu_mask
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-lcore-mask=$host_cpu_mask
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
