---
name: pdf
description: 读取与处理 PDF——提取文本/表格、合并拆分、提取指定页。当用户涉及 PDF 文件处理时使用。需要本机 Python + pypdf / pdfplumber。
---

# PDF 处理

用 Python 处理 PDF。文本/表格提取用 `pdfplumber`，页面操作（合并/拆分/提取页）用 `pypdf`。通过 Bash/PowerShell 运行脚本。

## 前置
依赖库：`pypdf`、`pdfplumber`（安装包已自动装好；缺失则 `pip install pypdf pdfplumber -i https://pypi.tuna.tsinghua.edu.cn/simple`）。

## 常见任务

### 提取文本
```python
import pdfplumber
with pdfplumber.open("文件.pdf") as pdf:
    for i, page in enumerate(pdf.pages, 1):
        print(f"--- 第 {i} 页 ---")
        print(page.extract_text() or "")
```

### 提取表格
```python
import pdfplumber
with pdfplumber.open("文件.pdf") as pdf:
    for page in pdf.pages:
        for table in page.extract_tables():
            for row in table:
                print(row)
```

### 合并 / 拆分 / 提取页
```python
from pypdf import PdfReader, PdfWriter
# 合并
w = PdfWriter()
for f in ["a.pdf", "b.pdf"]:
    for p in PdfReader(f).pages: w.add_page(p)
with open("合并.pdf", "wb") as out: w.write(out)
# 提取第 1-3 页
r = PdfReader("文件.pdf"); w = PdfWriter()
for p in r.pages[0:3]: w.add_page(p)
with open("前三页.pdf", "wb") as out: w.write(out)
```

## 原则
- 扫描件（图片型 PDF）提不出文字，需要 OCR——遇到时如实告诉用户。
- 表格结构复杂时，先打印看清结构再处理。
- 处理完告诉用户输出文件路径。
