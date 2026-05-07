# iTerm2 美化一键脚本及常见问题排查清单

# 一、iTerm2 美化一键执行脚本

说明：脚本适用于 macOS 系统，已整合「安装iTerm2→Oh My Zsh→配色→字体→主题→插件」全流程，无需手动分步操作；执行前确保已安装 Homebrew（若未安装，脚本会自动尝试安装）。

## 1\. 脚本内容（直接复制保存）

```bash
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

```

## 2\. 脚本使用方法

1. 打开「终端」（默认终端即可，无需提前打开iTerm2）；

2. 创建脚本文件：输入 `vim iterm\-beautify\.sh`，按 `i` 进入编辑模式；

3. 复制上面的脚本内容，粘贴到文件中，按 `Esc`，输入 `:wq` 保存并退出；

4. 赋予脚本执行权限：输入 `chmod \+x iterm\-beautify\.sh`；

5. 执行脚本：输入 `\./iterm\-beautify\.sh`，等待执行完成（过程中可能需要输入电脑密码，正常输入即可）。

# 二、常见问题排查清单（高频问题\+解决方案）

## 问题1：图标乱码（Powerlevel10k 提示符显示方框、问号）

### 原因

Nerd Font 未安装成功、未选择正确字体，或 Powerlevel10k 配置向导未完成。

### 解决方案

1. 重新安装字体：执行 `brew reinstall \-\-cask font\-hack\-nerd\-font`；

2. 设置字体：打开 iTerm2 → ⌘\+, → Profiles → Text → Font，选择「Hack Nerd Font Mono」，大小14\-15pt（确认无其他字体干扰）；

3. 重新执行主题配置：终端输入 `p10k configure`，全程按提示选择「Nerd Font」相关选项（一般是默认选项，直接回车即可）；y

4. 若仍乱码：重启 iTerm2，输入 `source \~/\.zshrc` 生效配置。

## 问题2：配色不生效（导入配色后，界面无变化）

### 原因

配色未正确导入、未选中生效，或 iTerm2 配置冲突。

### 解决方案

1. 重新导入配色：打开 iTerm2 → ⌘\+, → Profiles → Colors → Color Presets → Import，选中 `\~/iterm2\-colors/schemes/` 下的目标配色（如 Dracula\.itermcolors），导入后在列表中点击选中该配色；

2. 检查 Profiles 选择：确保当前生效的 Profiles 是「Default」（或你正在使用的 Profiles），避免配置错 Profiles；

3. 重置配色缓存：关闭 iTerm2 所有窗口，重新打开，若仍不生效，重启电脑；

4. 备选方案：直接下载单个配色文件（如 Dracula），导入后生效（下载地址：https://draculatheme\.com/iterm/）。

## 问题3：插件加载失败（自动补全不显示、语法不高亮）

### 原因

插件未安装成功、\.zshrc 配置错误，或插件加载命令缺失。

### 解决方案

1. 检查插件是否安装成功：
            

    - 自动补全插件：查看目录 `\~/\.oh\-my\-zsh/custom/plugins/zsh\-autosuggestions` 是否存在，不存在则重新执行 `git clone https://github\.com/zsh\-users/zsh\-autosuggestions $\{ZSH\_CUSTOM:\-\~/\.oh\-my\-zsh/custom\}/plugins/zsh\-autosuggestions`；

    - 语法高亮插件：执行 `brew list \| grep zsh\-syntax\-highlighting`，无输出则重新执行 `brew install zsh\-syntax\-highlighting`。

2. 检查 \.zshrc 配置：
            

    - 输入 `vim \~/\.zshrc`，确认 plugins 一行是 `plugins=\(git zsh\-autosuggestions zsh\-syntax\-highlighting\)`（无多余空格、无拼写错误）；

    - 确认 \.zshrc 末尾有一行 `source $\(brew \-\-prefix\)/share/zsh\-syntax\-highlighting/zsh\-syntax\-highlighting\.zsh`（语法高亮插件必需）。

3. 重新生效配置：输入 `source \~/\.zshrc`，重启 iTerm2 即可。

## 问题4：脚本执行报错「Permission denied」（权限不足）

### 原因

未给脚本赋予执行权限，或脚本文件本身权限异常。

### 解决方案

重新执行权限命令：`chmod \+x iterm\-beautify\.sh`，再执行 `\./iterm\-beautify\.sh`；若仍报错，输入 `sudo \./iterm\-beautify\.sh`（输入电脑密码即可）。

## 问题5：Powerlevel10k 主题不生效（提示符还是默认样式）

### 原因

\.zshrc 中 ZSH\_THEME 配置错误，或主题未正确安装。

### 解决方案

1. 检查主题安装路径：查看 `\~/\.oh\-my\-zsh/custom/themes/powerlevel10k` 是否存在，不存在则重新执行 `git clone \-\-depth=1 https://github\.com/romkatv/powerlevel10k\.git $\{ZSH\_CUSTOM:\-$HOME/\.oh\-my\-zsh/custom\}/themes/powerlevel10k`；

2. 检查 \.zshrc 配置：输入 `vim \~/\.zshrc`，确认 `ZSH\_THEME=\&\#34;powerlevel10k/powerlevel10k\&\#34;`（注意斜杠是 /，不是 \\）；

3. 重新生效配置：`source \~/\.zshrc`，执行 `p10k configure` 完成配置，重启 iTerm2。

## 问题6：Homebrew 安装失败（脚本报错「brew: command not found」）

### 原因

网络问题（无法访问 GitHub），或系统版本过低。

### 解决方案

1. 手动安装 Homebrew：输入命令 `/bin/bash \-c \&\#34;$\(curl \-fsSL https://raw\.githubusercontent\.com/Homebrew/install/HEAD/install\.sh\)\&\#34;`，若网络超时，切换手机热点重试；

2. 检查系统版本：macOS 需在 10\.15 及以上，低于该版本需升级系统后再执行脚本。

# 三、补充说明

- 脚本执行过程中，若提示「是否替换 \.zshrc」，直接回车确认即可（脚本仅修改主题和插件相关配置，不删除原有其他配置）；

- 若想更换配色/字体，直接在 iTerm2 偏好设置中修改，无需重新执行脚本；

- 若美化后想恢复默认，删除 `\~/\.oh\-my\-zsh`、`\~/iterm2\-colors` 目录，卸载 iTerm2 后重新安装即可。

> （注：文档部分内容可能由 AI 生成）
