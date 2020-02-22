if [[ $EUID -ne 0 ]]; then
   echo You are not the ROOT!;
else
   echo You are the ROOT!;
fi

adduser Tom;
echo "Tom:111" | chpasswd;
usermod -aG wheel Tom;

echo "What user do you want to modify?";

read name;

until id $name &> /dev/null;
do
   echo "Sorry, no such user, enter again";
   read name;
done

echo "OK, the user is in the system";

while :
do

echo "Choose action: 1 - set a password expiry date";
echo "               2 - change a command shell";
echo "               3 - change a home directory";
echo "               4 - exit";

read choice;

case $choice in
   [1] ) 
        echo "Enter a number of days for the expiration date"
        read days;
        chage -M $days $name;
        chage --list $name;;

   [2] ) 
        echo "What shell do you want to set?";
        echo "1 - /bin/sh, 2 - /bin/bash, 3 - /sbin/nologin";
	grep $name /etc/passwd
        read bro;
        case $bro in
            [1] )
                 usermod -s /bin/sh $name;;
            [2] )
                 usermod -s /bin/bash $name;;
            [3] )
                 usermod -s /sbin/nologin $name;;
        esac
	grep $name /etc/passwd;;

   [3] ) echo "Enter path to new directory:"
         read path;
	 if [ ! -d "$path" ]; then
         mkdir $path;
	 fi;
         usermod -d $path $name;
         chown -R $name $path;
         chmod -R ugo+rw $path;
         echo "New directory is:"
         eval echo ~$name;;
		 
   [4] ) echo "Good bye"
	     exit 0;;
esac

done
