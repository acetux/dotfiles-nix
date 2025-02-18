{ config, pkgs, ... }:

# https://wiki.nixos.org/wiki/Encrypted_DNS
# https://www.reddit.com/r/NixOS/comments/spwyo3/change_dns_server/
# https://github.com/DNSCrypt/dnscrypt-proxy
# https://dnscrypt.info/faq/

let
  hasIPv6Internet = false; # Add backup IPv6 DNS servers when enabling!
  StateDirectory = "dnscrypt-proxy";
in
{
  # Make sure systemd-resolved is fully disabled:
  services.resolved.enable = false;
  boot.initrd.services.resolved.enable = false;

  # Make sure systemd-networkd is fully disabled:
  systemd.network.enable = false;
  boot.initrd.systemd.network.enable = false;

  # Make sure encrypted DNS servers don't get overridden:
  networking = {
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
    resolvconf.enable = false;
    dhcpcd.extraConfig = "nohook resolv.conf"; # In case dhcpcd is enabled
    networkmanager.dns = "none"; # In case NetworkManager is enabled
  };

  # Set dnscrypt-proxy 2 listeners in /etc/resolv.conf for certain software like policyd-spf (mail) which doesn't work otherwise:
  environment.etc = {
    "resolv.conf" = {
      text = ''
        nameserver 127.0.0.1
        nameserver ::1
      '';
      mode = "0444"; # Default
    };
  };

  # dnscrypt-proxy 2
  services.dnscrypt-proxy2 = {
    enable = true; # Nixpkgs: "dnscrypt-proxy" | https://github.com/DNSCrypt/dnscrypt-proxy | Supports "Anonymized DNSCrypt"
    settings = {
      # See https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"; # See https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        cache_file = "/var/lib/${StateDirectory}/public-resolvers.md";
      };

      # Use servers reachable over IPv6 if "hasIPv6Internet = true;"
      ipv6_servers = hasIPv6Internet;
      block_ipv6 = !(hasIPv6Internet);

      cache_min_ttl = 0;
      cache_neg_min_ttl = 0;
      cache_neg_max_ttl = 60;

      lb_strategy = "first";

      listen_addresses = [
        "127.0.0.1:53"
        "[::1]:53"
      ];
      bootstrap_resolvers = [
        "9.9.9.9:53"
        "[2620:fe::fe]:53"
      ]; # Put valid standard resolver addresses here. Your actual queries will not be sent there. If you're using DNSCrypt or Anonymized DNS and your lists are up to date, these resolvers will not even be used.
      netprobe_address = "9.9.9.9:53";

      require_dnssec = true;
      require_nolog = true;
      require_nofilter = false;

      dnscrypt_servers = true;
      doh_servers = true;

      server_names = [
        # Click on entries to see the IP-address: https://dnscrypt.info/public-servers/
        "quad9-dnscrypt-ip4-filter-pri" # Quad9 (anycast) dnssec/no-log/filter 9.9.9.9 - 149.112.112.9 - 149.112.112.112 Ping 3.4ms
        "quad9-dnscrypt-ip6-filter-pri" # Quad9 (anycast) dnssec/no-log/filter 2620:fe::fe - 2620:fe::9 - 2620:fe::fe:9
        #"dnscry.pt-geneva-ipv4" # Ping 7.6ms
        #"dnscry.pt-frankfurt-ipv4" Already used in relays Ping 10.2ms
        #"digitalprivacy.diy-dnscrypt-ipv4" # Ping 12.3ms
        #"dct-de" # Ping reject
        "dns.digitale-gesellschaft.ch" # DoH Ping 4.4ms
        "dns.digitale-gesellschaft.ch-ipv6" # DoH
        #"cloudflare" # DoH Ping 7.9ms
      ];

      # Doesn't Work (Could instead configure outside of NixOS by setting services.dnscrypt-proxy2.configFile="/etc/dnscrypt-proxy/dnscrypt-proxy.toml";):
      #skip_incompatible = true; # Skip resolvers incompatible with anonymization instead of using them directly.
      #routes = [
      #  # A route maps a server name ("server_name") to a relay that will be used to connect to that server anonymously.
      #  {
      #    server_name = "quad9-dnscrypt-ip4-filter-pri" via=[
      #    # IPv4
      #    "anon-dnswarden-swiss" # Ping 4.2ms
      #    #"dnscry.pt-anon-geneva-ipv4" # Used in server_names Ping 7.6ms
      #    "dnscry.pt-anon-frankfurt-ipv4" # 10.2ms
      #    "anon-cs-ch" # Ping 11.8ms
      #    ];
      #  }
      #  {
      #    server_name = "quad9-dnscrypt-ip6-filter-pri" via=[
      #    # IPv6
      #    "dnscry.pt-anon-geneva-ipv6"
      #    "dnscry.pt-anon-frankfurt-ipv6"
      #    ];
      #  }
      #];
    };
  };
  systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = StateDirectory;
}
