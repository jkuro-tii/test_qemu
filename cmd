sudo chmod a+rw result/*
#/usr/local/bin/
/usr/bin/qemu-system-x86_64 -m 8G,maxmem=10G --drive format=raw,file=result/nixos.img -object memory-backend-file,size=16M,share=on,mem-path=/dev/shm/ivshmem,id=hostmem \
-device ivshmem-doorbell,vectors=2,chardev=id -chardev socket,path=/tmp/ivshmem_socket,id=id -net nic -net user,hostfwd=tcp::22222-:22
#-device ivshmem-doorbell,vectors=2,chardev=id  -chardev socket,path=/tmp/ivshmem_socket,id=id -net nic -net user,hostfwd=tcp:127.0.0.1:33333-33333:22,model=e1000
#-object memory-backend-file,id=mem1,share=on,mem-path=./virtio_pmem.img,size=13M -device virtio-pmem-pci,memdev=mem1,id=mem1

#qemu-system-x86_64 -m 8G,maxmem=10G --drive format=raw,file=result/nixos.img  -device ivshmem-plain,memdev=hostmem -object memory-backend-file,size=16M,share=on,mem-path=/dev/shm/ivshmem,id=hostmem 
