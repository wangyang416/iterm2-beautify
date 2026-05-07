#!/bin/bash
# iTerm2 美化一键脚本（整合全流程，兼容macOS）
# 作者：自动整理，适配新手操作

# 第一步：检查并安装 Homebrew（必备依赖）
if ! command -v brew > /dev/null 2>&1; then
    echo "🔔 未检测到 Homebrew，正在自动安装..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # 配置 Homebrew 环境变量（临时生效，避免后续命令报错）
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✅ Homebrew 已安装，跳过安装步骤"
fi

# 第二步：安装 iTerm2
if ! command -v iterm2 > /dev/null 2>&1 && [ ! -d "/Applications/iTerm.app" ]; then
    echo "🔔 正在安装 iTerm2..."
    brew install --cask iterm2
else
    echo "✅ iTerm2 已安装，跳过安装步骤"
fi

# 第三步：安装 Oh My Zsh（Shell 基础）
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🔔 正在安装 Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh 已安装，跳过安装步骤"
fi

# 第四步：下载配色方案（Dracula、Solarized等热门配色）
if [ ! -d "$HOME/iterm2-colors" ]; then
    echo "🔔 正在下载 iTerm2 配色库..."
    git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git ~/iterm2-colors
else
    echo "✅ 配色库已下载，跳过下载步骤"
fi

# 第五步：安装 Nerd Font（解决图标乱码，推荐 Hack Nerd Font）
if ! fc-list | grep -q "Hack Nerd Font"; then
    echo "🔔 正在安装 Hack Nerd Font（解决图标乱码）..."
    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font
else
    echo "✅ Hack Nerd Font 已安装，跳过安装步骤"
fi

# 第六步：安装 Powerlevel10k 主题（最强 Zsh 主题）
P10K_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_PATH" ]; then
    echo "🔔 正在安装 Powerlevel10k 主题..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_PATH"
else
    echo "✅ Powerlevel10k 主题已安装，跳过安装步骤"
fi

# 第七步：安装必备插件（自动补全+语法高亮）
# 7.1 自动补全插件 zsh-autosuggestions
AUTO_SUGGEST_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$AUTO_SUGGEST_PATH" ]; then
    echo "🔔 正在安装 zsh-autosuggestions（自动补全）..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTO_SUGGEST_PATH"
else
    echo "✅ zsh-autosuggestions 已安装，跳过安装步骤"
fi

# 7.2 语法高亮插件 zsh-syntax-highlighting
if ! brew list | grep -q "zsh-syntax-highlighting"; then
    echo "🔔 正在安装 zsh-syntax-highlighting（语法高亮）..."
    brew install zsh-syntax-highlighting
else
    echo "✅ zsh-syntax-highlighting 已安装，跳过安装步骤"
fi

# 第八步：配置 .zshrc（启用主题和插件，覆盖原有配置，不删除其他内容）
echo "🔔 正在配置 .zshrc 文件..."
# 替换 ZSH_THEME 为 powerlevel10k
sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
# 替换 plugins 为 必备插件（保留 git 基础插件）
sed -i '' 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
# 新增 zsh-syntax-highlighting 加载命令（避免插件不生效）
if ! grep -q "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ~/.zshrc; then
    echo 'source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc
fi

# 第九步：生效配置
echo "🔔 正在生效配置..."
source ~/.zshrc

# 完成提示
echo -e "\n🎉 一键美化脚本执行完成！"
echo -e "📌 后续手动操作（仅2步，必做）："
echo -e "1. 打开 iTerm2 → 按 ⌘+, 打开偏好设置 → Profiles → Colors → Color Presets → Import"
echo -e "   选中 ~/iterm2-colors/schemes/ 下的 .itermcolors 文件（推荐：Dracula、Catppuccin Mocha）"
echo -e "2. 打开 iTerm2 终端，输入命令：p10k configure → 按提示完成主题配置（图标、配色、提示符）"
echo -e "3. 字体设置：Profiles → Text → Font 选择 Hack Nerd Font Mono，大小设为14-15pt"
echo -e "\n❓ 若出现问题，查看下方「常见问题排查清单」"

