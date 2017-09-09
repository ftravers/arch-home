#!/bin/bash


function install_yaourt_package {
    local package_name=$1
    local package_prefix=$2
    local yaourt_url="${package_prefix}/${package_name}/${package_name}.tar.gz"    
    cmd="wget http://aur.archlinux.org/packages/${yaourt_url}"
    eval $cmd

    cmd="tar xvfz ${package_name}.tar.gz"
    eval $cmd

    cmd="cd $package_name"
    eval $cmd

    su $USER
    makepkg -s
    exit

    cmd="sudo pacman -U ${package_name}${package_query_version}_x86_64.pkg.tar.xz"
    eval $cmd

    cd
}


package_name="package_query"
package_prefix="pa"
install_yaourt_package $package_name $package_prefix

package_name="yaourt"
package_prefix="ya"
#install_yaourt_package $package_name $package_prefix





# package_query_version=1.1.1
# yaourt_version=1.1.1

# wget http://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz



# cd package_query
# makepkg _s


# sudo pacman _U yaourt_${yaourt_version}_any.pkg.tar.xz 
