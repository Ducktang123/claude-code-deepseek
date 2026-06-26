---
name: pptx
description: 读取、创建或修改 PowerPoint 演示文稿（.pptx）——提取文字、批量生成幻灯片、套用版式。当用户涉及 PPT/pptx 文件处理时使用。需要本机 Python + python-pptx。
---

# PPT 演示文稿处理 (.pptx)

用 Python 的 `python-pptx` 库读写 PPT。通过 Bash/PowerShell 运行 Python 脚本完成。

## 前置
依赖库：`python-pptx`（安装包已自动装好；缺失则 `pip install python-pptx -i https://pypi.tuna.tsinghua.edu.cn/simple`）。

## 常见任务

### 读取文字
```python
from pptx import Presentation
prs = Presentation("输入.pptx")
for i, slide in enumerate(prs.slides, 1):
    print(f"--- 第 {i} 页 ---")
    for shape in slide.shapes:
        if shape.has_text_frame:
            print(shape.text_frame.text)
```

### 新建幻灯片
```python
from pptx import Presentation
from pptx.util import Inches, Pt
prs = Presentation()
# 标题页
slide = prs.slides.add_slide(prs.slide_layouts[0])
slide.shapes.title.text = "汇报标题"
slide.placeholders[1].text = "副标题 / 作者"
# 标题+内容页
slide = prs.slides.add_slide(prs.slide_layouts[1])
slide.shapes.title.text = "要点"
tf = slide.placeholders[1].text_frame
tf.text = "第一点"
tf.add_paragraph().text = "第二点"
prs.save("输出.pptx")
```

## 原则
- 用版式（slide_layouts）生成更整齐，少手动摆位置。
- 中文注意字号和字体，避免溢出。
- 处理完告诉用户输出文件路径。
