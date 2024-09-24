# This is the name of the Volume that is being created
volume="UserVol"


disk_manager() {

  # Gets all the users on the system while ignoring administration accounts
  for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody' | grep -v 'root' | grep -v 'Admin'| grep -v 'admin'); do

    echo "User: $user"

    if [ -d "/Volumes/$volume/$user" ]; then
      echo "$user directory already exists"
      chmod -R 777 /Volumes/$volume/$user

    else
      echo "Creating directories"

      # Creating the directory
      mkdir /Volumes/$volume/$user
      echo "Directory created"

      # Loop for setting up the new directory for the user
      for d in Desktop Documents Downloads; do
        echo "Directory in progress: $d"

        # Assigning variables
        oldir="/Users/$user"
        oldird="$oldir/$d"
        newdir="/Volumes/$volume/$user"
        newdird="$newdir/$d"

        # Copying from old directory to new one
        cp -r $oldird $newdir
        echo "$oldird copied to $newdir"

        # Removing old directory
        rm -rf $oldird
        echo "$oldird removed."

        # Creating symlink
        ln -s $newdird $oldir
        echo "Symlink created between $newdird - $oldir"

        # Change permissions of the directory so they are
        # accessiable to the user
        chmod -R o=rwx $newdird
        echo "Permissions changed for $newdird"
        echo "------------"
      done
    fi

    echo "------------"
  done
}


# Check if the directory already exists
if [ -d "/Volumes/$volume" ]; then
  echo "Directory exists!"
  echo "------------"
  disk_manager

else
  echo "Directory does not exist."
  echo ""
  diskutil apfs addVolume disk3 apfs $volume -quota 70g -reserve 10g
  echo "------------"
  disk_manager
fi
