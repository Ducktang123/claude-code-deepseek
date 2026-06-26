---
name: docx
description: 读取、创建或修改 Word 文档（.docx）——提取文本、生成报告、批量替换、调整格式。当用户涉及 Word/docx 文件处理时使用。需要本机 Python + python-docx。
---

# Word 文档处理 (.docx)

用 Python 的 `python-docx` 库读写 Word 文档。通过 Bash/PowerShell 运行 Python 脚本完成。

## 前置
依赖库：`python-docx`（安装包已自动装好；若缺失：`pip install python-docx -i https://pypi.tuna.tsinghua.edu.cn/simple`）。

## 常见任务

### 读取/提取文本
```python
from docx import Document
doc = Document("输入.docx")
for p in doc.paragraphs:
    print(p.text)
# 表格
for table in doc.tables:
    for row in table.rows:
        print([c.text for c in row.cells])
```

### 新建文档
```python
from docx import Document
doc = Document()
doc.add_heading("标题", level=1)
doc.add_paragraph("正文段落。")
doc.add_paragraph("要点", style="List Bullet")
t = doc.add_table(rows=1, cols=2); t.style = "Light Grid Accent 1"
doc.save("输出.docx")
```

### 批量查找替换（保留格式）
遍历 `doc.paragraphs` 与表格单元格，在 `run.text` 上做替换。

## 原则
- 先用临时脚本验证读出来的结构，再做修改。
- 中文字体可设置 `run.font.name` 并配 `w:eastAsia`，避免中文显示异常。
- 处理完告诉用户输出文件路径。
