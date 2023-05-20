return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  keys = {
    { "<leader>di", "<Cmd>lua require'jdtls'.organize_imports()<CR>" },
    { "<leader>cf", "<cmd>lua vim.lsp.buf.format()<CR>" }
  },
  config = function ()
    local jdtls = require "jdtls"
    local jdtls_path = "/opt/homebrew/Cellar/jdtls/1.22.0/libexec"
    local root_markers = {'gradlew', '.git'}
    local root_dir = require('jdtls.setup').find_root(root_markers)
    local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
    local workspace_folder = os.getenv("WORKPLACE") .. "work/disney/" .. project_name

    local config = {
      -- The command that starts the language server
      -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
      cmd = {
        "/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", jdtls_path.."/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
        "-configuration", jdtls_path.."/config_mac",
        "-data", workspace_folder,
      },
      -- 💀
      -- This is the default if not provided, you can remove it. Or adjust as needed.
      -- One dedicated LSP server & client will be started per unique root_dir
      root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

      -- Here you can configure eclipse.jdt.ls specific settings
      -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      -- for a list of options
      settings = {
        java = {},
      },

      -- Language server `initializationOptions`
      -- You need to extend the `bundles` with paths to jar files
      -- if you want to use additional eclipse.jdt.ls plugins.
      --
      -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
      --
      -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
      init_options = {
        bundles = {}
      },
    }

    jdtls.start_or_attach(config)
  end,
}
