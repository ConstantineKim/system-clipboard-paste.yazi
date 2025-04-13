-- Meant to run at async context. (yazi system-clipboard-paste)

return {
    entry = function()
        -- 获取当前活动标签页的当前目录
        local current_dir = tostring(cx.active.current.dir.url)

        -- 调用 ClipBoard 工具的 paste 命令
        local status, err =
            Command("cb")
            :arg("paste")
            :arg(current_dir)
            :spawn()
            :wait()

        if status and status.success then
            ya.notify({
                title = "System Clipboard",
                content = "Successfully pasted the file(s) from system clipboard",
                level = "info",
                timeout = 5
            })
            -- 刷新当前目录以显示新粘贴的文件
            ya.manager_emit("reload", { path = current_dir })
        else
            ya.notify({
                title = "System Clipboard",
                content = string.format(
                    "Could not paste file(s) from system clipboard: %s",
                    status and status.code or err
                ),
                level = "error",
                timeout = 5
            })
        end
    end
}
