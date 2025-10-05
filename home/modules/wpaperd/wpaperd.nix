{ ... }:
{
  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "30m";
        mode = "center";
        sorting = "random";
      };
      any = {
        path = "/home/cmcraft/Pictures/wallapapers";
      };
    };
  };
}