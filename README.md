# JSONToModel

Objective-C JSON转Model工具
<h3> 基本实现</h3>
1、实现了基本的json数据解析为模型 <br/>
2、实现了json数据里面的嵌套，eg：字典[key/value], 数组等<br/>
3、添加了网络请求的参数来进行处理<br/>
4、只生成了.h文件部分，.m文件部分根据用户需求进行处理</br>
5、移出原fork框架中不需要的部分</br>
6、注意生成的属性是无序的，不能与json数据中的字段顺序保持一致</br>

<h3>结果</h3>
1、首先生成右边的模型 <br/>
2、基于1的操作之后，点击生成文件。在log下找到路径，可以找到对应的文件 <br>

若是出现什么错误，可以查看下面打印的log；
<h3>操作详图</h3>
<div align="center">
<img src="https://github.com/RANSAA/ModelCreation/blob/master/caputer.png" height="480" width="1280" >
</div>

