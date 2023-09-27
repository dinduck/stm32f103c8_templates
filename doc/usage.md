# 简单使用

- `make` 生成项目
- `make burn` 烧录
- `make debug` 烧录
- `make erase` 擦写
- `cmake cbuild` 使用 `CMake` 构建项目


## 添加源文件与链接库

`CMake` 
- 源文件：修改 10 行的 `file`, 后面跟上源码即可
- 头文件: 修改 `include_directories`
- 库：修改 `target_link_librarues`, 链接 `libc` 就 添加 `c` 即可


`Make`
- 源文件: 在 `C_SOURCES` 添加
- 头文件: 在 `C_INCLUDES` 添加
- 库: 在 `LINS` 添加

