<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.bfuture.app.saas.util.Constants"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" import="java.util.*" pageEncoding="GBK"%>
<%@page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.io.File"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%!
public static String toUtf8String(String s) {
    StringBuffer sb = new StringBuffer();
     for (int i=0;i<s.length();i++) {
         char c = s.charAt(i);
         if (c >= 0 && c <= 255) {
             sb.append(c);
         } else {
             byte[] b;
             try {
                 b = Character.toString(c).getBytes("utf-8");
             } catch (Exception ex) {
                 System.out.println(ex);
                 b = new byte[0];
             }
             for (int j = 0; j < b.length; j++) {
                  int k = b[j];
                  if (k < 0) k += 256;
                  sb.append("%" + Integer.toHexString(k).
                  toUpperCase());
             }
        }
     }
     return sb.toString();
} 
%>
<%		
		// ��ȡ��ǰ��¼�û���Ϣ
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}
		SysScmuser currUser = (SysScmuser)obj;
		// ִ���ĵ��ϴ�����
		FileItemFactory  factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		PrintWriter pw = response.getWriter(); 
		JSONObject ro = new JSONObject();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
		String fileDate = df.format(new Date());
		try {
			upload.setHeaderEncoding("UTF-8");
			List<FileItem> list = upload.parseRequest(request);
			FileItem fileItem = list.get(0);
			Long filesize = fileItem.getSize()/1024; // ��λkb
			if(filesize > 5120){ // �������5M
				ro.put("err","�������ܴ���5M");
			}else{
				String name = fileItem.getName().substring(fileItem.getName().lastIndexOf("\\") + 1);
				name = currUser.getSgcode()+"_"+fileDate + toUtf8String(name);
				File uploadedFile = new File(Constants.PromotionApplUrl + File.separator + name);
				uploadedFile.getParentFile().mkdirs();
				System.out.println(uploadedFile.exists());
				if(uploadedFile.exists()){
					ro.put("err","ͬ�������Ѿ����ڣ������������ϴ�����");
				}
				fileItem.write(new File( Constants.PromotionApplUrl + File.separator + name ));		// ����linux�£���Ŀ��
				ro.put("fileDate",fileDate);
			}
		} catch (FileUploadException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			pw.println(JSONObject.fromObject(ro).toString());
			pw.close();
		}
 %>