import pandas as pd

#导入Superstore.csv文件,数据不兼容,可改encoding为 "latin1"
df =pd.read_csv("Superstore.csv",encoding="latin1")

print(df.shape)                #数据规模,查看有多少行多少列
print(df.head())               #查看前几行正式数据(默认为5行)
print(df.describe())           #查看数值分布(count：有效数据数量; mean：平均值; std：标准差; min：最小值25% 第一四分位数50% 中位数75%：第三四分位数 ;max：最大值)
print(df.info())               #查看数据结构,行列及其数据类型
print(df.isnull().sum())       #缺失值数量     #无缺失值,不用特意数据清洗

#修改不合适的数据类型
#发现order date(下单日期) 与 ship date(发货日期) 的数据类型都是object,调整为datetime64[ns]

df["Order Date"] = pd.to_datetime(df["Order Date"])
df["Ship Date"] = pd.to_datetime(df["Ship Date"])
print(df.info())

#设置新变量: 发货等待天数 Shipping Date
df["Shipping Days"] = (df["Ship Date"] - df["Order Date"]).dt.days
print(df.info())

#查看order date(下单日期) 与 ship date(发货日期) 以及 shipping date
print(df[["Order Date","Ship Date","Shipping Days"]].head())  #把列名放在一个列表中,再统一调用整个列表
print(df["Shipping Days"].describe())

#保存为csv文件,便于mysql处理
df.to_csv("cleaned_SuperStore.csv",index=False)
print("ok!")


