---
name: xlsx
description: 读取、创建或修改 Excel 表格（.xlsx）——提取数据、汇总统计、生成报表、写公式与样式。当用户涉及 Excel/xlsx 文件处理时使用。需要本机 Python + openpyxl。
---

# Excel 表格处理 (.xlsx)

用 Python 的 `openpyxl` 库读写 Excel。通过 Bash/PowerShell 运行 Python 脚本完成。数据量大、做分析时也可用 `pandas`。

## 前置
依赖库：`openpyxl`（安装包已自动装好；缺失则 `pip install openpyxl -i https://pypi.tuna.tsinghua.edu.cn/simple`）。

## 常见任务

### 读取
```python
import openpyxl
wb = openpyxl.load_workbook("数据.xlsx", data_only=True)  # data_only 读公式结果
ws = wb.active
for row in ws.iter_rows(values_only=True):
    print(row)
```

### 创建/写入
```python
import openpyxl
wb = openpyxl.Workbook(); ws = wb.active; ws.title = "汇总"
ws.append(["姓名", "金额"])
ws.append(["张三", 100])
ws["C1"] = "=SUM(B2:B10)"          # 写公式
from openpyxl.styles import Font
ws["A1"].font = Font(bold=True)     # 样式
wb.save("输出.xlsx")
```

### 数据分析（推荐 pandas）
```python
import pandas as pd
df = pd.read_excel("数据.xlsx")
print(df.groupby("类别")["金额"].sum())
df.to_excel("结果.xlsx", index=False)
```

## 原则
- 先读几行确认表头和列含义，再处理。
- 区分"公式"和"公式结果"（`data_only=True`）。
- 处理完告诉用户输出文件路径。
