{ ... }:

{
  programs.ssh.knownHosts = {

    domaPcServer-initrd = {
      hostNames = [
        "[10.100.100.100]:2227"
      ];

      publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILWjGsXeAtGIEBoclDPnKF+gTvMsNZGrsqh42DvGsPEj";
    };

  };
}