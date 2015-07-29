# UnionpayOpen

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/unionpay_open`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unionpay_open'
# or
gem 'unionpay_open', :git => 'git://github.com/yanyingwang/unionpay_open.git'
```

And then execute:

	$ bundle

Or install it yourself as:

	$ gem install unionpay_open

## Usage


### 配置
```ruby
UnionpayOpen.config do |unionpay|
  unionpay.pfx_file = 'tmp/acp.pfx'
  unionpay.pfx_file_password = '000000'
  unionpay.ca_file = 'tmp/acp.cer'
  unionpay.merchant_no = '111111111111111'
end

```


### 查看
配置载入完成后，可以通过如下命令查看配置文件内容：
```ruby
UnionpayOpen.pfx_file
UnionpayOpen.merchant_no

UnionpayOpen.pkcs12
UnionpayOpen.pkcs12.to_s
UnionpayOpen.pkcs12.certificate.serial.to_s

UnionpayOpen.x509_certificate.public_key.to_s
UnionpayOpen.x509_certificate.serial.to_s
```

### 前台交易请求地址

```ruby
response = UnionpayOpen::Wap.front_trans_req( front_url: 'http://test.com',
											  order_id: "abcd1qaz",
											  txn_amt: "10000" )
# response 正常情况将输入银联请求结果，为HTML页面代码。
```

**注意**：

1. 方法名支持按照ruby规范，用snake方式（下划线连接单词）书写，Gem会在内部自动进行转换以适应银联接口。

2. 调用Gem时传入的参数默认只需包含必要字段(如front_trans_req只需front_url, order_id, txn_amt)，其他字段如果也作为参数传入，将覆盖UnionpayOpen内部已经默认定义的值。

3. debug需要，可在方法后添加一个block，来查看请求到银联的参数，如下示例代码：

```ruby
# 查看其他字段默认值：
UnionpayOpen::Wap.front_trans_req {}

# 查看请求到银联接口的全部参数：
UnionpayOpen::Wap.front_trans_req( front_url: 'http://test.com',
											  order_id: "abcd1qaz",
											  txn_amt: "10000" ) {}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/unionpay_open. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.
