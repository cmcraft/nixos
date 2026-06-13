{ config, ... }:
{
  services.tuned = {
    enable = true;
    profiles."accelerator-performance" = {
      main.include = "";
      cpu.governor = "performance";
      cpu.energy_perf_bias = "performance";
      cpu.min_perf_pct = 100;
      cpu.boost = 1;
      cpu.force_latency = 99;
      acpi.platform_profile = "performance";
      disk.readahead = ">4096";
      vm.dirty_bytes = "40%";
      vm.dirty_background_bytes = "10%";
      sysctl."vm.swappiness" = 10;
      scheduler.sched_min_granularity_ns = 10000000;
      scheduler.sched_wakeup_granularity_ns = 15000000;
      video.panel_power_savings = 0;
    };
    recommend = {
      "accelerator-performance" = {
        # Auto-apply on desktop/AC power; could add virt check etc.
      };
    };
  };
}