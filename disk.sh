fdiskP(){

        for i in `cat /proc/partitions|grep -v name|grep -v ram|awk '{print $4}'|grep -v '^$'|grep -v '[0-9]$'|grep -v 'vda'|grep -v 'xvda'|grep -v 'sda'|grep -e 'vd' -e 'sd' -e 'xvd'`;
        do
                #判断指定目录是否被挂载
                isR=`df -P|grep $setup_path`
                if [ "$isR" != "" ];then
                        echo "Error: The $setup_path directory has been mounted."
                        return;
                fi

                isM=`df -P|grep '/dev/${i}1'`
                if [ "$isM" != "" ];then
                        echo "/dev/${i}1 has been mounted."
                        continue;
                fi

                #判断是否存在未分区磁盘
                isP=`fdisk -l /dev/$i |grep -v 'bytes'|grep "$i[1-9]*"`
                if [ "$isP" = "" ];then
                                #开始分区
                                fdisk -S 56 /dev/$i << EOF
n
p
1


wq
EOF
 sleep 5
                        #检查是否分区成功
                        checkP=`fdisk -l /dev/$i|grep "/dev/${i}1"`
                        if [ "$checkP" != "" ];then
                                #格式化分区
                                mkfs.ext4 /dev/${i}1
                                mkdir $setup_path
                                #挂载分区
                                sed -i "/\/dev\/${i}1/d" /etc/fstab
                                echo "/dev/${i}1    $setup_path    ext4    defaults    0 0" >> /etc/fstab
                                mount -a
                                df -h
                        fi
          done
)

                        
                        
                        
                        
                        
