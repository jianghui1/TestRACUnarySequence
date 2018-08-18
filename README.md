##### `RACUnarySequence`作为`RACSequence`的子类，`Unary`的意思是`一元的`，注释`Private class representing a sequence of exactly one value`也说明了该类只包含一个值。

完整测试用例[在这里](https://github.com/jianghui1/TestRACUnarySequence)。

看看`.m`中方法的作用
***

    + (instancetype)return:(id)value {
    	RACUnarySequence *sequence = [[self alloc] init];
    	sequence.head = value;
    	return [sequence setNameWithFormat:@"+return: %@", [value rac_description]];
    }
重写父类的方法，返回只有一个值的序列。

测试用例：

    - (void)test_return
    {
        RACUnarySequence *sequence = [RACUnarySequence return:@"xxx"];
        NSLog(@"return -- %@", sequence);
        
        // 打印日志：
        /*
         2018-08-16 17:21:03.940582+0800 TestRACUnarySequence[15973:17015192] return -- <RACUnarySequence: 0x600000238820>{ name = , head = xxx }
         */
    }
***
    
    - (RACSequence *)tail {
    	return nil;
    }
返回`nil`。也就是说该类只有一个值。

测试用例：

    - (void)test_tail
    {
        RACUnarySequence *sequence = [RACUnarySequence return:@[@1, @2, @3]];
        NSLog(@"tail -- %@", sequence.tail);
        
        // 打印日志：
        /*
         2018-08-16 17:22:49.841689+0800 TestRACUnarySequence[16078:17019928] tail -- (null)
         */
    }
***

    - (instancetype)bind:(RACStreamBindBlock (^)(void))block {
    	RACStreamBindBlock bindBlock = block();
    	BOOL stop = NO;
    
    	RACSequence *result = (id)[bindBlock(self.head, &stop) setNameWithFormat:@"[%@] -bind:", self.name];
    	return result ?: self.class.empty;
    }
以`head`值为参数调用`block`获取一个`RACSequence`对象`result`。如果`result`存在，返回；如果不存在，返回空序列。

测试用例：

    - (void)test_bind
    {
        RACUnarySequence *sequence = [RACUnarySequence return:@(1)];
        RACSequence *s = [sequence bind:^RACStreamBindBlock{
            return ^(id value, BOOL *stop) {
                return [RACUnarySequence return:@(100)];
            };
        }];
        NSLog(@"bind -- %@", s);
        
        // 打印日志：
        /*
         2018-08-16 17:25:01.532451+0800 TestRACUnarySequence[16176:17026442] bind -- <RACUnarySequence: 0x6000002341c0>{ name = , head = 100 }
         */
    }
***

后面的一些关于 序列化、格式化日志 的方法不再分析。

##### 综上，这个类只保存一个序列值。
