class fcron {
    
    package { "fcron":
        category => "sys-process",
        ensure   => latest,
    }

    file { "/etc/cron.d":
        ensure => directory,
        owner  => "root",
        group  => "root",
        mode   => "0755",
    }
    
    exec { "fcrontab -u systab /etc/crontab":
        path    => "/usr/bin:/usr/sbin:/bin",
        unless  =>  "test -f /var/spool/fcron/systab",
        require => Package["fcron"]
    }

    exec { "check_system_crontabs":
        command     => "/usr/sbin/check_system_crontabs -v -i -f",
        refreshonly => true,
        require     => Package["fcron"],
    }

    service { "fcron":
        ensure    => running,
        enable    => true,
        require   => Package["fcron"],
    }
}
