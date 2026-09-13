import pandas as pd
import matplotlib.pyplot as plt

plt.rcParams["font.sans-serif"] = ["Microsoft YaHei"]
plt.rcParams["axes.unicode_minus"] = False

#概览:
df =  pd.read_csv("Superstore.csv",encoding="latin1")
#print(df[['Sales','Quantity','Profit','Discount']].describe())

#四个地区（Region）的销售额和利润表现有什么差异？
'''需要得到每个 Region 的：

① 总销售额 Sales
② 总利润 Profit
③ 总销量 Quantity'''
result = df.groupby("Region")[["Sales","Profit","Quantity"]].sum()
#print(result)

#四地区销售额柱状图:
plt.bar(result.index,result["Sales"])
plt.title("sales by region")
plt.xlabel("region")
plt.ylabel("sales")
#plt.show()

#四地区利润额柱状图:
plt.bar(result.index,result["Profit"])
plt.title("profit of region")
plt.xlabel("region")
plt.ylabel("profit")
#plt.show()

#求四个地区的利润率
#利润率 = 总利润 ÷ 总销售额 × 100%
profit_rate = round(result["Profit"] / result["Sales"],3)
#print(profit_rate)

#四地区利润率柱状图:
plt.bar(result.index,profit_rate)
plt.title("profit rate of region")
plt.xlabel("region")
plt.ylabel("profit rate")
#plt.show()

#折扣与利润的关系
'''先建立折扣区间：
0 ～ <0.1
0.1 ～ <0.2
0.2 ～ <0.3
≥0.3
然后计算每个区间的：
订单数量
平均利润
总利润
平均折扣'''

df["discount_level"] = pd.cut(
    df["Discount"],
    bins= [0,0.1,0.2,0.3,1],
    labels= ["基本无优惠","小优惠","不错的优惠","大甩卖"],
    right= False        #右边不包含,左边包含
)

result_level = df.groupby("discount_level").agg(         #agg() = 分组以后，一次性对不同列做不同的统计。
    订单数量 = ("Profit","count"),
    平均利润 = ("Profit","mean"),
    总利润 = ("Profit","sum"),
    平均折扣 = ("Discount","mean")
)
print(result_level)

#绘制图表: 折扣与利润的关系
plt.figure()

plt.bar(result_level.index,result_level["平均利润"])
plt.title("the relation of discount and profit")
plt.xlabel("discount level")
plt.ylabel("average profit")
plt.show()








