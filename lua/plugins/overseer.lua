return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle" },
    opts = function()
      require("overseer").setup({})
      local ok, overseer = pcall(require, "overseer")
      if ok then
        overseer.register_template({
          name = "sbatch current script",
          builder = function()
            return {
              cmd = { "bash", "-lc" },
              args = { "sbatch %:p" },
              components = { "default", "unique" },
            }
          end,
          condition = { filetype = { "sh" } },
        })
        overseer.register_template({
          name = "tail newest slurm out",
          builder = function()
            return {
              cmd = { "bash", "-lc" },
              args = { "jid=$(squeue -h -u $USER -o %A | head -n1); tail -f slurm-${jid}.out" },
              components = { "default", "unique" },
            }
          end,
        })
      end
    end,
  },
}