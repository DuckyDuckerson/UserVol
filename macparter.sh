# Name of the Volume that is being created
volume="UserVol"


disk_manager() {

  # Gets all the users on the system while ignoring administration accounts
  for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody' | grep -v 'root' | grep -v 'Admin'| grep -v 'admin'); do

    echo "User: $user"
    echo "Creating directories"

    mkdir /Volumes/$volume/$user
    echo "Directory created"

    for d in Desktop Documents Downloads; do
      echo "Directory in progress: $d"

      oldir="/Users/$user"
      oldird="$oldir/$d"
      newdir="/Volumes/$volume/$user"
      newdird="$newdir/$d"

      cp -r $oldird $newdir
      echo "$oldird copied to $newdir"

      rm -rf $oldird
      echo "$oldird removed."

      ln -s $newdird $oldir
      echo "Symlink created between $newdird - $oldir"

      chmod -R o=rwx $newdird
      echo "Permissions changed for $newdird"
      echo "------------"

    done
    echo "------------"
  done

}


if [ -d "/Volumes/$volume" ]; then
  echo "Directory exists!"
  echo "------------"

else
  echo "Directory does not exist."
  echo ""
  diskutil apfs addVolume disk3 apfs $volume -quota 70g -reserve 10g
  echo "------------"
  disk_manager
fi
