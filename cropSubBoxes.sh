for (( v=$1; v<=$2; v++ ));
do
	vID=`printf "v%03d" "$v"`
	echo $v $vID
	cd $vID
	for kk in *.jpg;
	do
		k=`echo $kk | sed 's/\.jpg//g'`
		echo $k
		convert $kk -crop 256x216+0+0 $k\.1.jpg
		convert $kk -crop 256x216+256+0 $k\.2.jpg
		convert $kk -crop 256x216+512+0 $k\.3.jpg
		convert $kk -crop 256x216+0+216 $k\.4.jpg
		convert $kk -crop 256x216+256+216 $k\.5.jpg
		convert $kk -crop 256x216+512+216 $k\.6.jpg
		convert $kk -crop 256x216+128+108 $k\.7.jpg
		convert $kk -crop 256x216+384+108 $k\.8.jpg
	done
	cd ..

done
