/**
 * 
 */
package test;

import java.lang.instrument.Instrumentation;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.IdentityHashMap;
import java.util.Map;
import java.util.Stack;

/**
 * @author J.C.J
 *         --
 */
public class JavaSizeOf
{
	private static Instrumentation	inst;

	public static void premain(String agentArgs, Instrumentation inst)
	{
		JavaSizeOf.inst = inst;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception
	{
		// System.out.println(JavaSizeOf.sizeof(new String("1234567")));
		// System.out.println(JavaSizeOf.sizeof(new String("1234")));
		System.out.println(JavaSizeOf.sizeof(new Object()));
		// System.out.println(JavaSizeOf.sizeof(new int[] { 1, 2, 3 }));
		// System.out.println(JavaSizeOf.sizeof(null));
	}

	public static long sizeof(Object o)
	{

		Map<Object, Object> visited = new IdentityHashMap<Object, Object>();
		Stack<Object> visiting = new Stack<Object>();
		visiting.add(o);
		long size = 0;
		while (!visiting.isEmpty())
		{
			size += analysis(visiting, visited);
		}
		return size;
	}

	/**
	 * analysis java object size recursively.
	 * 
	 * @param visiting
	 * @param visited
	 * @return
	 */
	protected static long analysis(Stack<Object> visiting, Map<Object, Object> visited)
	{
		Object o = visiting.pop();
		if (skip(o, visited))
		{
			return 0;
		}
		visited.put(o, null);
		// array.
		if (o.getClass().isArray() && !o.getClass().getComponentType().isPrimitive())
		{
			if (o.getClass().getName().length() != 2)
			{
				for (int i = 0; i < Array.getLength(o); i++)
				{
					visiting.add(Array.get(o, i));
				}
			}
		}
		// object.
		else
		{
			Class<?> clazz = o.getClass();
			while (clazz != null)
			{
				Field[] fields = clazz.getDeclaredFields();
				for (Field field : fields)
				{
					if (Modifier.isStatic(field.getModifiers()))
					{
						continue;
					}
					if (field.getType().isPrimitive())
					{
						continue;
					}
					field.setAccessible(true);
					try
					{
						visiting.add(field.get(o));
					}
					catch (Exception e)
					{
						assert false;
					}
				}
				clazz = clazz.getSuperclass();
			}
		}
		return inst.getObjectSize(o);
	}

	/**
	 * <pre>
	 * skip statistics.
	 * </pre>
	 * 
	 * @param o
	 * @param visited
	 * @return
	 */
	protected static boolean skip(Object o, Map<Object, Object> visited)
	{
		if (o instanceof String)
		{
			if (o == ((String) o).intern())
			{
				return true;
			}
		}
		return o == null || visited.containsKey(o);
	}

}
