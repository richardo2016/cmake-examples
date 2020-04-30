## 关于 Objective-C

Objective-C 是你编写 OS X 和 iOS 应用时的首要编程语言. 它是 C 语言的超集, 提供了面向对象的能力和一个动态运行时. ObjectiveC 继承了 C 的语法, 原子类型和控制流预发, 并且新增了一些定义类和方法的语法. 它也新增了对对象图管理和对象字面量的语言级支持, 与此同时提供了动态的类型约束和绑定, 把大部分语言定义的责任推迟到到了运行时.

Most object-oriented development environments consist of several parts:

大部分面向对象的开发环境由一下几部分构成:

- 一门面向对象的语言
- 一个对象的库
- 开发工具套件
- 一个运行时环境

本文档是关于上述开发环境的第一个组件 —— 编程语言的. 这份文档也提供了一个学习第二个组件, Objective-C 应用框架的一部分基础 —— 总的来说也就是 Cocoa. 运行时环境在一个单独的文档 [Objective-C Runtime Programming Guide] 中讲述.

[Objective-C Runtime Programming Guide]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008048

**译者注** 翻译这段的时候, 苹果正在推 Swift, OS X 已经进化为 MacOS 品牌了

### 谁需要阅读这份文档

这份文档是为可能会对这些内容感兴趣的读者所准备的:

- 用 Objective-C 编程
- 了解 Cocoa 应用框架的基础

这份文档同时介绍了 Objective-C 所依赖的面向对象模型, 以及这门语言完整的文档. 它聚焦于 Objective-C 对 C 的扩展部分, 而非 C 语言本身.

因为这不是关于 C 的文档, 它假设读者预先有关于 C 语言的知识. 然而使用 Objective-C 的面向对象编程和使用 ANSI C 的过程式编程是完全不同的, 所以即便你不是一个熟练的 C 程序员的话, 你也不会遇到阻碍.

### 文档的组织结构

The following chapters cover all the features Objective-C adds to standard C.
下面的章节涵盖了 Objective-C 在 C 之外添加的所有特性.

- [Objects, Classes, and Messaging]
- [Defining a Class]
- [Protocols]
- [Declared Properties]
- [Categories and Extensions]
- [Associative References]
- [Fast Enumeration]
- [Enabling Static Behavior]
- [Selectors]
- [Exception Handling]
- [Threading]

[Objects, Classes, and Messaging]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocObjectsClasses.html#//apple_ref/doc/uid/TP30001163-CH11-SW1
[Defining a Class]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocDefiningClasses.html#//apple_ref/doc/uid/TP30001163-CH12-SW1
[Protocols]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocProtocols.html#//apple_ref/doc/uid/TP30001163-CH15-SW1
[Declared Properties]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocProperties.html#//apple_ref/doc/uid/TP30001163-CH17-SW1
[Categories and Extensions]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocCategories.html#//apple_ref/doc/uid/TP30001163-CH20-SW1
[Associative References]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocAssociativeReferences.html#//apple_ref/doc/uid/TP30001163-CH24-SW1
[Fast Enumeration]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocFastEnumeration.html#//apple_ref/doc/uid/TP30001163-CH18-SW1
[Enabling Static Behavior]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocStaticBehavior.html#//apple_ref/doc/uid/TP30001163-CH16-SW1
[Selectors]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocSelectors.html#//apple_ref/doc/uid/TP30001163-CH23-SW1
[Exception Handling]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocExceptionHandling.html#//apple_ref/doc/uid/TP30001163-CH13-SW1
[Threading]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocThreading.html#//apple_ref/doc/uid/TP30001163-CH19-SW1

这份文档的结尾的一份术语表提供了在 Objective-C 和面向对象编程中特定的术语定义.

### 约定(Conventions)

这份文档对电脑声音和斜字体有特殊的使用. 电脑声音词表达了其对应文本的词句 (正如他们所展示的那样). 斜字体表明了可能有歧义的的词语. 举个例子, 下面这个语法:

`@interface`_ClassName(CategoryName)_

的意思, `@interface` 和两个括号是必须的, 但你可以自己选择类名和分类的名字.

**译者注** 这句话的意思是, 上面的 `@interface` 是关键字, _Classname(CategoryName)_ 中的 `Classname` 和 `CategoryName` 是可以自己取名的.

在展示示例代码的地方, 省略号指代那些实质往往是使用的, 但被省略的部分:

```objective-c
- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    ...
}
```

### 其它参考

[Object-Oriented Programming with Objective-C]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/OOP_ObjC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40005149

如果你从未使用面向对象编程变成来创建应用, 你应该看一下 [Object-Oriented Programming with Objective-C]. 如果你有使用过其它面向对象开发环境的经验(比如 C++ 和 Java), 你也应该考虑下读这本书, 因为它们有很多常见概念, 习语和 Objective-C 不太一样. [Object-Oriented Programming with Objective-C] 被设计为可以帮助你更加熟悉以 Objective-C 开发者的视角看待面向对象的开发. 它阐明了一些面向对象设计的内涵, 并为你提供了一些编写面向对象程序的人可能喜欢的套路.

### 运行时系统

[Objective-C Runtime Programming Guide]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008048

[Objective-C Runtime Programming Guide] 描述了 Objective-C 运行时的各个方面, 并教你如何使用它.

[Objective-C Runtime Reference]:https://developer.apple.com/documentation/objectivec/objective_c_runtime

[Objective-C Runtime Reference] 讲述了 Objective-C 运行时系统支持库中的数据结构和函数. 你的程序可以使用这些接口来和 Objective-C 运行时系统进行交互. 举个例子, 你可以添加函数和方法, 或者获取一个包含了所有已经加载的类定义的列表.

### 内存管理

Objective-C 支持三种内存管理机制, 自动垃圾回收和引用计数:

- Automatic Reference Counting (ARC), where the compiler reasons about the lifetimes of objects.
- Manual Reference Counting (MRC, sometimes referred to as MRR for “manual retain/release”), where you are ultimately responsible for determining the lifetime of objects. <br />Manual reference counting is described in Advanced Memory Management Programming Guide.

- Garbage collection, where you pass responsibility for determining the lifetime of objects to an automatic “collector.”<br /> Garbage collection is described in Garbage Collection Programming Guide. (Not available for iOS—you cannot access this document through the iOS Dev Center.)

[Advanced Memory Management Programming Guide]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html#//apple_ref/doc/uid/10000011i
[Garbage Collection Programming Guide]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/GarbageCollection/Introduction.html#//apple_ref/doc/uid/TP40002431

- 自动引用计数(ARC), 编译器在这种机制中推导对象的生命周期.
- 手动内存计数(MRC, 也被称为 MRR, 表示 "manual retain/release"), 在这种机制中你完全负责对象的生命周期进行控制.<br /> 手动引用计数在 [Advanced Memory Management Programming Guide] 有所讲述
- 垃圾回收, 在这种机制下你要负责决定对象在自动"收集器"中存活的市场.<br />垃圾回收在 [Garbage Collection Programming Guide] 中有所讲述. (不过这个机制对 iOS 无效 —— 你无法在 iOS 开发者中心找到对应的文档)

## 原文

https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1