# GJAlertController
##简介
UIAlertController是一个在iOS8才被加入的类，在低于iOS8版本的设备上无法使用，此库可让使用者在低版本中也可以使用UIAlertController。

也就是说，你在开发的时候尽管使用UIAlertController，就当它是iOS很早版本就有的类，不必去在代码中判断如果iOS版本小于8，而去用AlertView或者ActionSheet。

当app运行的iOS版本中没有UIAlertController的时候，GJAlertController这个类库会自动用UIAlertView、UIActionSheet去帮你实现你想要的功能。

###使用：
__第一种 拷贝导入__

__1.直接把GJAlertController文件夹下的GJAlertAction.h/.m、GJAlertController.h/.m、UIViewController+Alert.h/.m文件拷贝到工程中即可。__

__第二种 使用cocoapods管理__

__使用cocoapods__

__在Podfile文件中添加：pod 'GJAlertController。__

__然后重新update。__



###用法：就是直接用UIAlertController，不用考虑版本兼容的问题。


```C
//创建instance
UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"title" message:@"message" preferredStyle:UIAlertControllerStyleAlert];

//添加action
[alertVC addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}]];
    
//添加action
[alertVC addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}]];

//添加textField, 由于UIAlertView最多只支持添加两个textField，所以这里如果你添加了多个textField，iOS8之前最多显示两个，iOS8及其之后会显示出多个。
[alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.placeholder = @"huhu";
}];

//展示
[self presentViewController:alertVC animated:YES completion:nil];
```
如果要使用actionSheet把创建时候的type改成UIAlertControllerStyleActionSheet。

如果想测试GJAlertController的作用，又没有iOS7的设备的话，可以直接使用GJAlertController、GJAlertAction及其相关的枚举值，用法就是把上面用法中的UI前缀换成GJ就可以了，但是显示的时候不能调用


```C
[self presentViewController:alert animated:YES completion:nil];
```

如果要显示Alert调用：

```C
[alert testShow];
```

如果要显示ActionSheet调用：


```C
[actionSheet testShowActionSheet];
```


