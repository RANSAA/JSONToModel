# JSONToModel

mainly for create model from json data
<h3> 基本实现</h3>
1、实现了基本的json数据解析为模型 <br/>
2、实现了json数据里面的嵌套，eg：字典[key/value], 数组等<br/>
3、添加了网络请求的参数来进行处理
4、添加clear，在生成新的内容之前，不希望保留上一次的输出，需要点击clear按钮；
5、在.m 文件中自动生成modelCustomPropertyMapper的方法代码

<h3>结果</h3>
1、首先生成右边的模型 <br/>
2、基于1的操作之后，点击生成文件。在log下找到路径，可以找到对应的文件 <br>

若是出现什么错误，可以查看下面打印的log；
<h3>操作详图</h3>
<div align="center">
<img src="https://github.com/RANSAA/ModelCreation/blob/master/caputerZib.jpg" height="720" width="640" >
</div>


<h3>bug修复：</h3>
1、文件生成的时候的.m 文件错误

