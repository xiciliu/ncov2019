package util.thread;

public class ThreadUtil {

	/**
     * 通过线程组获得线程
     *
     * @param threadId
     * @return
     */
    public static Thread findThread(long threadId) {
        ThreadGroup group = Thread.currentThread().getThreadGroup();
        while(group != null) {
            Thread[] threads = new Thread[(int)(group.activeCount() * 1.2)];
            int count = group.enumerate(threads, true);
            for(int i = 0; i < count; i++) {
                if(threadId == threads[i].getId()) {
                    return threads[i];
                }
            }
            group = group.getParent();
        }
        return null;
    }
    

    //杀线程
    //对对应的线程进行interrupt() ,安全结束sleep中的进程的方式
    public static boolean killThreadByName(String name){
         ThreadGroup currentGroup = Thread.currentThread().getThreadGroup();
	     int noThreads = currentGroup.activeCount();
	     Thread[] lstThreads = new Thread[noThreads];
	     currentGroup.enumerate(lstThreads);
	     //Logger.info("现有线程数" + noThreads);
	     for (int i = 0; i < noThreads; i++){
	          String nm =lstThreads[i].getName();
	          //Logger.info("线程号：" + i + " = " + nm);
	          if (nm.equals(name)) {
	                  lstThreads[i].interrupt();
	                    return true;
	          }
	     }
        return false;
    }
}
