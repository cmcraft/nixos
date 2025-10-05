{ ... }:
{
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "Hyprland";
        user = "cmcraft";
      };
      default_session = initial_session;
    };
  };
}