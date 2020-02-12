package com.yaowei.ncov.module;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
//import org.apache.tomcat.util.http.fileupload.FileItem;
//import org.apache.tomcat.util.http.fileupload.RequestContext;
//import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
//import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.nutz.dao.DaoException;
import org.nutz.img.Images;
import org.nutz.ioc.loader.annotation.IocBean;
import org.nutz.lang.util.NutMap;
import org.nutz.mvc.Mvcs;
import org.nutz.mvc.Scope;
import org.nutz.mvc.annotation.AdaptBy;
import org.nutz.mvc.annotation.At;
import org.nutz.mvc.annotation.Attr;
import org.nutz.mvc.annotation.Fail;
import org.nutz.mvc.annotation.Ok;
import org.nutz.mvc.annotation.POST;
import org.nutz.mvc.annotation.Param;
import org.nutz.mvc.impl.AdaptorErrorContext;
import org.nutz.mvc.upload.FieldMeta;
import org.nutz.mvc.upload.TempFile;
import org.nutz.mvc.upload.UploadAdaptor;

import com.yaowei.ncov.Global;


@IocBean // 还记得@IocBy吗? 这个跟@IocBy有很大的关系哦
@At("/upload")
//@Ok("json")
@Ok("json:{locked:'password|salt',ignoreNull:true}") //密码和salt也不可以发送到浏览器去
@Fail("http:500")
//@Filters(@By(type=CheckSession.class, args={"me", "/"})) //如果当前Session没有带me这个attr,就跳转到/页面,即首页.
public class Uploader extends BaseModule{

	

	 @POST
	 @At("/delfile")
	 @Ok("json")
	public Object deleteFile(@Param("idg")int idg,@Param("filename")String filename,HttpServletRequest request,
			HttpServletResponse response, AdaptorErrorContext err) throws ServletException, IOException {

		NutMap ret= new NutMap();
		ret.setv("ok", true);
		
		// 设置临时文件存储位置
		String base = Mvcs.getServletContext().getRealPath("/") + "uploadtemp";// 上传路径
		File file=new File(base+"/"+filename);
		if(!file.exists()) {
			
		}else {
			boolean t=file.delete();
			if(t) {ret.setv("msg", "");}
			else {
				ret.setv("ok", false).setv("msg", "Delete file failed");
			}
		}
		return ret;
		
	 }
	
	 @POST
	 /*@AdaptBy(type = UploadAdaptor.class,args = {"ioc:upload","${app.root}/WEB-INF/tmp"}) */
	 @AdaptBy(type=UploadAdaptor.class, args={"${app.root}/WEB-INF/tmp", "8192", "utf-8", "20000", "102400"})
	 @At("/addfile")
	 @Ok("json")
	 //@Ok("jsp:/WEB-INF/admin/official/official-edit.jsp")
	public Object uploadFile(@Param("file") TempFile[] tempFile, @Param("idg")int idg,HttpServletRequest request,
			HttpServletResponse response, AdaptorErrorContext err) throws ServletException, IOException {
		String msg = null;
		if (err != null && err.getAdaptorErr() != null) {
			msg = "文件大小不符合规定";
		} else if (tempFile == null) {
			msg = "空文件";
		} else {

		}

		NutMap ret= new NutMap();
		ret.setv("ok", true);
		if(!StringUtils.isBlank(msg)) {
			return ret.setv("ok", false).setv("msg", msg);
		}
		
		// 设置临时文件存储位置
		String base = Mvcs.getServletContext().getRealPath("/") + "uploadtemp";// 上传路径
		base=Global.tstfolder;
		File file = new File(base);
		if (!file.exists())
			file.mkdirs();
		
		
		List<NutMap> lnm=new ArrayList<NutMap>();
		for(TempFile tf: tempFile) {
			
			if(tf!=null) {
				File f=tf.getFile();						 // 这个是保存的临时文件
				FieldMeta meta = tf.getMeta();               // 这个原本的文件信息
			    String oldName = meta.getFileLocalName();    // 这个时原本的文件名称
			    String newName=new Date().getTime()+"_"+oldName;
			    //f.renameTo(new File(base+"/"+newName));
			    //FileUtil.moveFile(f.getAbsolutePath(), base+"/"+newName); //xici.jar
			    FileUtils.moveFile(new File(f.getAbsolutePath()), new File(base+"/"+newName));
			    
			    NutMap r= new NutMap();
			    r.setv("oldname", oldName);
			    r.setv("newname", newName);
			    r.setv("idg", idg);
			    
			    lnm.add(r);
			}
		}
		ret.setv("result", lnm);
		if(lnm.size()<=0) {
			ret.setv("ok",false);
		}
		
		return ret;
		
		//Item工厂
		/*
		DiskFileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		// 设置内存缓冲区，超过后写入临时文件
		factory.setSizeThreshold(10240000);		
		factory.setRepository(file);
		upload.setHeaderEncoding("utf-8");
		upload.setSizeMax(10*1024*1024*1024);
		try {
            //解析请求，将表单中每个输入项封装成一个FileItem对象
            List<FileItem> itemList=upload.parseRequest((RequestContext) request);
            for(FileItem item:itemList){
                //判断输入的类型是 普通输入项 还是文件
                if(item.isFormField()){
                    //普通输入项 ,得到input中的name属性的值
                    String name=item.getFieldName();
                    //得到输入项中的值
                    String value=item.getString("UTF-8");
                    System.out.println("name="+name+"  value="+value);
                }else{
                    //上传的是文件，获得文件上传字段中的文件名
                    //注意IE或FireFox中获取的文件名是不一样的，IE中是绝对路径，FireFox中只是文件名。
                    String fileName=item.getName();
                    System.out.println(fileName);
                    //返回表单标签name属性的值
                    String namede=item.getFieldName();
                    System.out.println(namede);

                   //方法一：保存上传文件到指定的文件路径
                    InputStream is=item.getInputStream();
                    FileOutputStream fos=new FileOutputStream("D:\\wps\\"+fileName);
                    byte[] buff=new byte[1024];
                    int len=0;
                    while((len=is.read(buff))>0){
                        fos.write(buff);
                    }

                    //方法二：保存到指定的路径
                    //将FileItem对象中保存的主体内容保存到某个指定的文件中。
                    // 如果FileItem对象中的主体内容是保存在某个临时文件中，该方法顺利完成后，临时文件有可能会被清除
                    item.write(new File("D:\\sohucache\\"+fileName));
                    is.close();
                    fos.close();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
		*/
		
	}
	
	 /*
	//这是为了上传头像图片，未完
	@AdaptBy(type=UploadAdaptor.class, args={"${app.root}/WEB-INF/tmp/user_avatar", "8192", "utf-8", "20000", "102400"})
    @POST
    @Ok(">>:/user/profile")
    @At("/avatar")
    public void uploadAvatar(@Param("file")TempFile tf,
            @Attr(scope=Scope.SESSION, value="me")int userId,
            AdaptorErrorContext err) {
        String msg = null;
        if (err != null && err.getAdaptorErr() != null) {
            msg = "文件大小不符合规定";
        } else if (tf == null) {
            msg = "空文件";
        } else {
        	/*
            UserProfile profile = get(userId);
            try {
                BufferedImage image = Images.read(tf.getFile());
                image = Images.zoomScale(image, 128, 128, Color.WHITE);
                ByteArrayOutputStream out = new ByteArrayOutputStream();
                Images.writeJpeg(image, out, 0.8f);
                profile.setAvatar(out.toByteArray());
                dao.update(profile, "^avatar$");
            } catch(DaoException e) {
                //log.info("System Error", e);
                msg = "系统错误";
            } catch (Throwable e) {
                msg = "图片格式错误";
            }
            *
        }

        if (msg != null)
            Mvcs.getHttpSession().setAttribute("upload-error-msg", msg);
    }
	*/
}
