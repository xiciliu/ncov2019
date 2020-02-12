
//dao.js和db.properties配合使用的时候
var ioc = {
        conf : {
            type : "org.nutz.ioc.impl.PropertiesProxy",
            fields : {
                paths : ["custom/"]
            }
        },
        dataSource : {
                factory : "$conf#make",
                args : ["com.alibaba.druid.pool.DruidDataSource", "db."],
                type : "com.alibaba.druid.pool.DruidDataSource",
                events : {
                    create : "init",
                        depose : 'close'
                }
        },
      dao : {
          type : "org.nutz.dao.impl.NutDao",
            args : [{refer:"dataSource"}]
      }
        
        
       /* 
        tmpFilePool : {
            type : 'org.nutz.filepool.NutFilePool',
            // 临时文件最大个数为 1000 个
            //args : [ "~/nutz/upload/tmps", 1000 ]
            args : [ "${app.root}/nutz/upload/tmps", 1000 ]
        },
        uploadFileContext : {
            type : 'org.nutz.mvc.upload.UploadingContext',
            singleton : false,
            args : [ { refer : 'tmpFilePool' } ],
            fields : {
                // 是否忽略空文件, 默认为 false
                ignoreNull : true,
                // 单个文件最大尺寸(大约的值，单位为字节，即 1048576 为 1M)
                //maxFileSize : 1048576,
                maxFileSize : 10485760,
                // 正则表达式匹配可以支持的文件名
                //nameFilter : '^(.+[.])(gif|jpg|png)$' 
                nameFilter : '^(.+[.])(tst)$'
            } 
        },
        ,myUpload : {
            type : 'org.nutz.mvc.upload.UploadAdaptor',
            singleton : false,
            args : [ { refer : 'uploadFileContext' } ] 
        }
        */
};

/*
//dao.js单个使用的时候
var ioc = {
        dataSource : {
            type : "com.alibaba.druid.pool.DruidDataSource",
            events : {
                create : "init",
                depose : 'close'
            },
            fields : {
                //url : "jdbc:mysql://127.0.0.1:3306/nutzbook",
            	url : "jdbc:sqlserver://localhost:1433;DatabaseName=pts",
                username : "sa",
                password : "sqlserver_sa",
                testWhileIdle : true, // 非常重要,预防mysql的8小时timeout问题
                //validationQuery : "select 1" , // Oracle的话需要改成 select 1 from dual
                maxActive : 100
            }
        },
        dao : {
            type : "org.nutz.dao.impl.NutDao",
            args : [{refer:"dataSource"}]
        }
};

*/