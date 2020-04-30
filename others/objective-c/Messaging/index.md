## 消息机制(Messaging)

[objc_msgSend]:https://developer.apple.com/documentation/objectivec/1456712-objc_msgsend

本章讲述了一个消息表达式如何被转化为对 [objc_msgSend] 函数的调用, 以及你怎样可以通过 name 参数引用到对应的方法. 同时, 本章揭示你怎样可以很好地利用 [objc_msgSend], 以及如果你确实需要, 你可以如何绕过动态绑定.

## objc_msgSend 函数

在 Objective-C 中, 消息直到运行时才绑定到方法实现上. 编译器会将下面这样的消息表达式转化为对消息函数 [objc_msgSend] 的调用:

```objective-c
[receiver message]
```

这个函数需要 receiver 和消息名 name (即 selector) 两个最重要的参数:

```objective-c
objc_msgSend(receiver, selector)
```

任何需要传给消息的参数也要体现在这里:

```objective-c
objc_msgSend(receiver, selector, arg1, arg2, ...)
```

这个消息函数做了所有动态绑定需要的工作:

- 首先它会寻找 selector 对应的 procedure (方法实现). 因为同名的方法可以被不同的类各自实现, 所以它具体所找到的 procedure 依赖于 receiver 的类
- 接着它会调用这个 procedure, 把收到的对象(实际上是指向这个对象数据的一个指针)和该方法中提到的其它参数传给这个 procedure.
- 最后, 它将 procedure 处理后的返回值作为自己的返回值.

> **注意** 编译器会自己生成对 messaging 函数的调用. 你不应该直接在你写的代码里调用它.

**译者注** 对于上面这个提醒, 确实, 在 Objective-C 里你不应该直接调用 [objc_msgSend], 但是如果你是用纯 C 完成同样的工作, 是必然要使用它的.

messaging 的关键在于编译器为每个类和对象构建出的数据结构. 每个类结构包含这两种必要因素:

- 指向父类的指针
- 类分发表(dispatch table). 这张表提供了一个 entries, 其中把方法选择器(method selectors)和具体到每个类中**该方法的实现**内存地址关联起来. `setOrigin::` 方法的 selector 会被关联到某个具体的 procedure 中实现了的 `setOrigin::` 的内存地址, `display` 方法的 selector 会关联掉 `display` 在 procedure 中实现了的 `display` 的内存地址, 以此类推.

当一个新对象被创建之后, 与它相关的内存就被分配了, 其实例变量也完成了初始化. 该对象变量首要需要关注的就是指向它类结构的指针. 这个指针被称为 `isa`, 它提供给了对象访问自己的类的能力, 以及经由自己的类, 访问其继承的所有父类的能力.

> **注意** 提一点不完全算这门语言的一个点, `isa` 指针对于运行在 Objective-C 运行时系统中的对象是必要的. 无论一个对象的数据结构定义的字段是什么, 这个对象都需要"等价于"结构体 `objc_object` (定义在 `objc/objc.h` 中). 然而几乎不需要创建你自己的一个根对象, 所有继承自 `NSObject` 或 `NSProxy` 的对象都会自动拥有 `isa` 变量

**译者注** 这里说的根对象主要是指 `NSObject` 和 `NSProxy`

类和对象结构中的这些要素如下所示:

![Figure 3-1](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Art/messaging1.gif)

当一个消息被发给一个对象的时候, messaging 函数跟随该对象的 `isa` 指针找到其类结构, 并在其中按照分发表(dispatch table)寻找方法 selector . 如果它无法在这个类中找到 selector , `objc_msgSend` 又会会跟随其父类的指针并按照分发表在父类中寻找方法 selector ...以此类推, `objc_msgSend ` 会逐级往上查找直到找到这个类或者抵达 `NSObject` 类. 一旦它定位到了这个 selector , 它就会调用该 selector 在 dispatch table 中对应的方法, 把 receiving object 的传给这个方法.

**译者注** 上一段中的 "messaging 函数" 就是指 `objc_msgSend`

这就是方法实现在运行时如何被选出来的方式 —— 或者用 OOP 的话来说, 这些方法是被动态绑定到消息的.

为了加速 messaging 的处理, 运行时系统会把用到的 selectors 及其对应方法地址缓存起来. 每个类有一份自己的缓存, 其中包含既继承自父类方法的 selectors , 也包含了在这个类中定义的方法的 selectors. 在搜索分发表(dispatch tables)之前, messaging 路由会优先检查 receiving object 的类上的这份缓存(这基于"已用过一次的方法很可能再次被调用"的理论). 如果方法 selector 确实在缓存中, 整个 messaing 链路只会比直接对那个方法的调用稍微慢一点. 只要程序运行起来一段足够时间以"活化"其缓存, 则几乎该程序中所有的消息都能找到缓存的方法. 在程序运行时, 缓存会动态地增加以容纳更多新的消息.

**译者注** 这段话值得注意的是, 用于存储 class 上的对 selector-method 关系的缓存的是动态增长的(其最后一句).

### 使用隐式函数

当 [objc_msgSend] 找到了实现了某个方法的 procedure 时, 它会调用该 procedure 并且其包含在消息中的所有参数传给这个 procedure. 同时它还会传递两个隐式参数:

- 接收消息中的对象(receiving object)
- 方法的 selector

这两个参数向方法的实现提供了明确的关于调用这个方法的消息表达式(message expression)的相关的两部分信息. 它们之所以被称为"隐式的", 是因为它们会并不会在定义这个方法的源代码中声明. 它们会在代码被编译的时候插入到实现中.

**译者注** 上面这段就是想说在 Objective-C 中 `[receiver selector]` 中 selector 方法函数签名中不会显式出现 receiver 和 selector, 这个行为靠编译器完成.

```objective-c
- strange
{
    id  target = getTheReceiver();
    SEL method = getTheMethod();
 
    if ( target == self || method == _cmd )
        return nil;
    return [target performSelector:method];
}
```

`self` 比这两个参数更有用. 实际上, 它就是 receiving object 的实例变量在方法定义中的体现.

### 获得一个方法的地址

唯一绕过动态绑定的方式是获取方法的地址, 然后以将其当做函数的方式来直接调用它. 这个操作在一个场景下是合适的, 即某个特定的方法会被连续执行很多次, 而你想避免在这个过程中每次方法被执行时要要走的 messaging 链路.

通过一个定义在 `NSObject` 类上的方法 `methodForSelector:`, 你可以查询某个方法对应的过程实现(procedure)的指针, 然后使用这个指针去调用该过程(procedure). `methodForSelector:` 返回的指针必须被小心地 cast 成合适的方法类型. 这个方法类型应该同时包括方法的返回和参数.

The example below shows how the procedure that implements the setFilled: method might be called:

下面这个例子展示了过程(procedure) 如何实现 `setFilled:` 方法:

```objective-c
void (*setter)(id, SEL, BOOL);
int i;
 
setter = (void (*)(id, SEL, BOOL))[target
    methodForSelector:@selector(setFilled:)];
for ( i = 0 ; i < 1000 ; i++ )
    setter(targetList[i], @selector(setFilled:), YES);
```

传给这个 procedure 的两个参数分别是 receiving object (self) 和 method selector (_cmd). 这些参数隐藏在方法的语法中, 但当该被当做函数调用的时候, 这两个参数必须被显式传递.

使用 `methodForSelector:` 来绕来动态绑定节省了被 messaging 流程所需要的大部分时间. 然而, 这样的节省应该只被应用在某个会被反复执行多次的特定的消息上, 比如上面这个例子中展示的循环.

Note that methodForSelector: is provided by the Cocoa runtime system; it’s not a feature of the Objective-C language itself.

注意, `methodForSelector:` 是由 Cocoa 运行时系统提供的; 它并非是 Objective-C 语言本身的一部分.

<!-- - procedure
- method
- selector
- messaging function(pure c level) -->

## 原文

https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtHwMessagingWorks.html#//apple_ref/doc/uid/TP40008048-CH104-SW1