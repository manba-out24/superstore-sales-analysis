# 一. 总体经营情况
# 1. 总销售额为:
USE superstore;
select SUM(Sales) from superstore_data;

#2. 总利润为:
select SUM(Profit) from superstore_data;

#3.总销量为:
select SUM(Quantity) from superstore_data;

#4. 一共有多少个订单明细
select COUNT(*) from superstore_data;

#5. 整合一下:
select SUM(Sales) as Total_Sales,
SUM(Profit) as Total_Profit,
SUM(Quantity) as Total_Quantity,
COUNT(*)  as Number from superstore_data;

#二. 地区分析
#查询每个地区的总销售额与总利润
SELECT Region as "地区" , SUM(Sales) as "总销售额",sum(Profit) as "总利润" from superstore_data GROUP by Region ORDER BY SUM(Sales) desc;

#三.整体综合练习
#Furniture、Office Supplies、Technology 三个大类中，哪个类别利润最高？
select Category as "类别", sum(Profit) as "利润" from superstore_data GROUP by Category order by sum(Profit) desc ;

#找出利润率最低的商品类别       #order by 中引用别名时,应该使用反引号(1右边的符号``)
select Category as "类别" , sum(Profit)/sum(Sales) as "Rate of Profit" from superstore_data group by Category order by `Rate of Profit`;

#找出 Sub-Category 中利润最低的 5 个子类别
select `Sub-Category` as "子类别",sum(Profit) as "利润", sum(Sales) as "销售额" from superstore_data GROUP BY `Sub-Category` order by sum(Profit) asc limit 5;

#销量最高的子类别Sub-Category
select `Sub-Category` as "子类别", sum(Quantity) as "销量" from superstore_data GROUP BY `Sub-Category` order by sum(Quantity) desc limit 1;

#找出销量最高的 5 个子类别，同时看看它们的总利润。
select `Sub-Category` as "子类别", sum(Quantity) as "销量", sum(Profit) as "总利润",sum(Sales) as "总销售额" from superstore_data GROUP by `Sub-Category` ORDER BY sum(Quantity) DESC limit 5 ;

#四.where (先筛选，再分组)
#在折扣大于等于 30% 的订单中，各个地区的总销售额和总利润分别是多少？
select Region as "地区",sum(Sales) as "总销售额", sum(Profit) as "总利润" from superstore_data where Discount >= 0.3 group by Region  order by sum(Profit);

#五.case when语法 

/* CASE WHEN 语法
CASE
    WHEN 条件 THEN 结果
    ELSE 其他结果
END
*/

# 临时新增一个“利润状态”字段。Profit > 0：显示“盈利” , Profit <= 0：显示“亏损"
select `Order ID`,
    Profit ,
    case 
         when Profit > 0 then "盈利"
    else   "亏损"
    end as "利润状态" 
from superstore_data ;

#六. having用法(先分组,后筛选)
/*哪些商品子类别整体处于亏损状态？
查询每个 Sub-Category 的：
子类别
总销售额
总利润
筛选条件：
只保留总利润小于 0 的子类别
最后按照总利润从低到高排序。*/
select `Sub-Category` as "子类别",sum(Sales) as "总销售额",sum(Profit) as "总利润" from superstore_data 
group by `Sub-Category` having sum(Profit) <0 order by sum(Profit) ASC ;

#七. 年度销售趋势
# 2015～2018 年，每年的销售额和利润分别是多少？哪一年销售额最高？
select sum(Sales) as "总销售额", sum(Profit) as "总利润",year(`Order Date`) as "年份" from superstore_data 
where YEAR(`Order Date`) >= 2015 and YEAR(`Order Date`) <= 2018  group by YEAR(`Order Date`)
order by sum(Sales) DESC ;

#月度销售分析
/*  2015～2018 年中，哪个月份的总销售额最高？
要求查询：
年份
月份
总销售额
总利润
按照销售额从高到低排序。*/
select YEAR(`Order Date`) as "年份", MONTH(`Order Date`) as "月份",sum(Sales) as "总销售额", sum(Profit) as "总利润"
from superstore_data  where YEAR(`Order Date`) >= 2015 and YEAR(`Order Date`) <= 2018 
GROUP BY MONTH(`Order Date`), YEAR(`Order Date`) order by sum(Sales) DESC;

#取前五个
select YEAR(`Order Date`) as "年份", MONTH(`Order Date`) as "月份",sum(Sales) as "总销售额", sum(Profit) as "总利润"
from superstore_data  where YEAR(`Order Date`) >= 2015 and YEAR(`Order Date`) <= 2018 
GROUP BY MONTH(`Order Date`), YEAR(`Order Date`) order by sum(Sales) DESC limit 5;

#哪些客户为公司贡献的利润最多？
/*查询每个 Customer Name 的：

① 客户姓名
② 总销售额
③ 总利润
④ 总购买数量

按照总利润从高到低排序，只取前 10 名客户。*/
select `Customer Name` as "客户姓名",sum(Sales) as "总销售额", sum(Profit) as "总利润", sum(Quantity) as "总购买数量"
from superstore_data group by `Customer Name` order by sum(Profit) DESC limit 10;

#八. 子查询
#把每笔订单按照利润划分成三个等级，并统计各等级的订单数量、总销售额和总利润。
/*分类规则：
利润 > 100 → 高利润
利润 0~100 → 中利润
利润 < 0 → 亏损

最终查询：
利润等级、订单数量、总销售额、总利润
并按照总利润从高到低排列。*/
select 
    count(*) as "订单数量" , 
    sum(Sales) as "总销售额", 
    sum(Profit) as "总利润",
    `利润等级`   
from (
    select 
        Sales, 
        Profit,
    case
        when Profit > 100 then "高利润"
        when Profit >0 and Profit <= 100 then "中利润"
        else "亏损"
    end as `利润等级`    
    from superstore_data   
) as t    
group by `利润等级`
order by sum(Profit) desc ;

#客户利润等级
/*分类规则：
总利润 > 1000 → 高价值客户
总利润 0～1000 → 普通客户
总利润 < 0 → 亏损客户

最终只需要得到：
客户等级 + 客户数量*/

SELECT `客户等级`,COUNT(*) as "客户数量"
from (
    SELECT 
        `Customer Name`,
        sum(profit),
    case
        when SUM(profit) > 100 then '高价值客户'
        when SUM(profit) >= 0 and SUM(profit) <= 100 then '普通客户'
        else '亏损客户'
    end as `客户等级`
    from superstore_data    
    group by `Customer Name`
) as t
group by `客户等级`;

#九. 聚合函数
#Consumer、Corporate、Home Office 三种客户类型，哪一种整体最赚钱？
/* 查询每个 Segment:
① 客户类型
② 总销售额
③ 总利润
④ 总购买数量
⑤ 平均订单利润
并按照总利润从高到低排序。*/
select Segment as "客户类型", sum(Sales) as "总销售额", sum(Profit) as "总利润",
sum(Quantity) as "总购买数量", AVG(Profit) as "平均订单利润"
from superstore_data
group by Segment order by sum(Profit) desc;

#窗口函数: 找出每个地区中利润最高的客户。(未完成,暂时跳过)
/*要求最终显示：
地区、客户姓名、总利润*/
select `Customer Name` as "客户姓名",
        Region as "地区",
        ROW_NUMBER() OVER (
            PARTITION BY Region
            ORDER BY `总利润` DESC
        ) as "排名"
from (
    select Region ,`Customer Name`, sum(Profit) as "总利润"
    from superstore_data
    group by Region,`Customer Name` 
) as t;

#十. 综合业务分析
/*哪些产品卖了很多钱，但实际上没赚多少钱？
查询每个 Product Name 的：
产品名称
总销售额
总利润
要求：
按照总销售额从高到低排序，只取前 20 个。*/
select `Product Name` as "产品名称", SUM(Sales) as "总销售额",  SUM(Profit) as "总利润"
from superstore_data
group by `Product Name` order by sum(Sales) desc limit 20;

/*这次我们不直接分析订单明细，而是把 Discount 分成几个区间：
0 ～ <0.1
0.1 ～ <0.2
0.2 ～ <0.3
>=0.3

然后统计每个折扣区间的：                                    0 ～ <0.1
                                                        0.1 ～ <0.2
                                                        0.2 ～ <0.3
                                                        >=0.3
① 订单数量
② 总销售额
③ 总利润
④ 平均利润
最后按折扣区间顺序排列。*/
select COUNT(*) as "订单数量" , SUM(Sales) as "总销售额" , sum(Profit) as "总利润", avg(Profit) as "平均利润",
case 
    when Discount >0 and Discount <=0.1 then "基本无优惠"
    when Discount >0.1 and Discount <=0.2 then "小优惠"
    when Discount >0.2 and Discount <=0.3 then "不错的优惠"
    else "大优惠"
end as "折扣评估"
from superstore_data
group by 
    case 
        when Discount >0 and Discount <=0.1 then "基本无优惠"
        when Discount >0.1 and Discount <=0.2 then "小优惠"
        when Discount >0.2 and Discount <=0.3 then "不错的优惠"
        else "大优惠"
    end;

#十一. join表连接(customers表与orders表)
# 查询每笔订单对应的客户姓名、客户类型、订单销售额和订单利润。    
select c.`Customer Name` as "客户名称" , c.`Segment` as "客户类型" ,o.`Sales` as "订单销售额" , o.`Profit` as "订单利润"
from customers c join orders o 
on c.`Customer ID` = o.`Customer ID` ;

#哪个客户类型带来的利润最高？
/*要求查询：
客户类型 Segment
总销售额
总利润
总购买数量*/
select c.Segment as "客户类型",sum(o.Sales) as "总销售额",sum(o.Profit) as "总利润" , sum(o.Quantity) as "总购买数量"
from customers c join orders o on c.`Customer ID` = o.`Customer ID` 
group by c.Segment order by sum(o.Profit) DESC;

#找出利润最高的 10 个客户。
/*要求通过 customers JOIN orders 查询：
客户姓名
客户类型
总销售额
总利润
按照总利润从高到低排序，只取前 10 名。*/
select c.`Customer Name` as "客户姓名", c.Segment as "客户类型", sum(o.Sales) as "总销售额", sum(o.Profit) as "总利润"
from customers c JOIN orders o on c.`Customer ID` = o.`Customer ID`
group by c.`Customer ID`,c.Segment,c.`Customer Name` order by sum(o.Profit) DESC limit 10;



