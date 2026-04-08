# Config

## img-clip

Paste clipboard images into markdown files and auto-upload to Tencent COS.

Press `<leader>h` in Neovim to paste a clipboard image. The image is uploaded to COS asynchronously, with a `![uploading...]()` placeholder replaced by the final URL on completion.

**Generated link format:**

```
![](https://bu44er-1313346488.cos.ap-shanghai.myqcloud.com/obsidian/<timestamp>.png?imageMogr2/quality/80&imageSlim)
```

### Prerequisites

1. **pngpaste** — saves macOS clipboard images to files

   ```sh
   brew install pngpaste
   ```

2. **coscli** — Tencent COS CLI ([GitHub](https://github.com/tencentyun/coscli))

   ```sh
   # Download for macOS ARM64
   mkdir -p ~/.local/bin
   curl -Lo ~/.local/bin/coscli https://github.com/tencentyun/coscli/releases/download/v1.0.8/coscli-v1.0.8-darwin-arm64
   chmod +x ~/.local/bin/coscli
   ```

3. **Configure coscli** with your Tencent Cloud credentials:

   ```sh
   coscli config init
   ```

   This creates `~/.cos.yaml`. You will need your **SecretId**, **SecretKey**, and bucket info from the [Tencent Cloud CAM console](https://console.cloud.tencent.com/cam/capi).

### Related files

- `lua/cos-upload.lua` — upload logic (clipboard → temp file → COS → markdown link)
- `lua/plugins/image-clip.lua` — keybinding (`<leader>h`) and [img-clip.nvim](https://github.com/hakonharnes/img-clip.nvim) plugin spec
