# role: mediawiki
class role::mediawiki {
    include ::mediawiki

    if hiera('role::mediawiki::use_strict_firewall', false) {
        # Cache proxies will never use port 80.

        ufw::allow { 'https port cp2':
            proto => 'tcp',
            port  => 443,
            from  => '107.191.126.23',
        }

        ufw::allow { 'https port cp3':
            proto => 'tcp',
            port  => 443,
            from  => '128.199.139.216',
        }

        ufw::allow { 'https port cp4':
            proto => 'tcp',
            port  => 443,
            from  => '81.4.109.133',
        }

        ufw::allow { 'https port cp8':
            proto => 'tcp',
            port  => 443,
            from  => '51.161.32.127',
        }

        ufw::allow { 'https port icinga':
            proto => 'tcp',
            port  => 443,
            from  => '185.52.1.76'
        }
    } else {
        ufw::allow { 'http port tcp':
            proto => 'tcp',
            port  => 80,
        }

        ufw::allow { 'https port tcp':
            proto => 'tcp',
            port  => 443,
        }
    }

    motd::role { 'role::mediawiki':
        description => 'MediaWiki server',
    }

    # $gluster_volume_backup = hiera('gluster_volume_backup', 'glusterfs2.miraheze.org:/mvol')
    # backup-volfile-servers=
    if !defined(Gluster::Mount['/mnt/mediawiki-static']) {
        gluster::mount { '/mnt/mediawiki-static':
          ensure    => mounted,
          volume    => hiera('gluster_volume', 'gluster1.miraheze.org:/mvol'),
        }
    }
}
