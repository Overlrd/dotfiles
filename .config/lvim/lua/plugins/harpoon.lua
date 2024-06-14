return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>1", false },
    { "<leader>2", false },
    { "<leader>3", false },
    { "<leader>4", false },
    {
      "<leader>&",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon buffer 1",
    },
    {
      "<leader>é",
      function()
        require("harpoon"):list():select(2)
      end,

      desc = "Harpoon buffer 2",
    },
    {
      '<leader>"',
      function()
        require("harpoon"):list():select(3)
      end,

      desc = "Harpoon buffer 3",
    },
    {
      "<leader>'",
      function()
        require("harpoon"):list():select(4)
      end,

      desc = "Harpoon buffer 4",
    },
  },
}
