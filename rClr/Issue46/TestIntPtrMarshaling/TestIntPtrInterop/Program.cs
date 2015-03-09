using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using RDotNet;

namespace TestIntPtrInterop
{
    public class Program
    {
        static void Main(string[] args)
        {
        }
    }

    public class MyType
    {
        public IntPtr intPtr;

        public SymbolicExpression Sexp { get; private set; }

        int val = 5;
        string str = "hello";

        static REngine engine
        {
            get
            {
                if(_engine==null)
                    _engine = REngine.GetInstance();
                return _engine;
            }
        }
        private static REngine _engine;

        static MyType()
        {
            Console.WriteLine("Entered MyType static constructor");
            Console.WriteLine("About to exit MyType static constructor");
        }

        MyType()
        {
            Console.WriteLine("About to create Sexp on MyType");
            Sexp = engine.CreateCharacter("Hello");
            Console.WriteLine("In ctor val is: {0}", val);
            Console.WriteLine("In ctor str is: {0}", str);
        }

        MyType(int v, byte[] array)
        {
            Console.WriteLine("In ctor (int, byte[]) got value: {0}, array len: {1}", v, array.Length);
        }

        void method()
        {
            Console.WriteLine("In method val is {0}", val);
            Console.WriteLine("In method str is: {0}", str);
        }

        int Value
        {
            get
            {
                return val;
            }
        }

        string Message
        {
            get
            {
                return str;
            }
        }

        void Values(ref int v, ref string s)
        {
            Console.WriteLine("In Values () v is {0}", v);
            Console.WriteLine("In Values () s is: {0}", s);
            v = val;
            s = str;
        }

        static void Fail()
        {
            throw new Exception();
        }

        public static MyType CreateWrapper(IntPtr ptr)
        {
            Console.WriteLine();
            Console.WriteLine(ptr.ToString());
            Console.WriteLine();
            return new MyType { intPtr = ptr };
        }

        public static void PrintIntPtr(MyType m)
        {
            Console.WriteLine(m.intPtr.ToString());
        }

        public static void PrintSexp(MyType m)
        {
            Console.WriteLine(m.Sexp.AsCharacter()[0]);
        }

        public void ForceGarbageCollection()
        {
            DotNetGc();
            engine.ForceGarbageCollection();
            DotNetGc();
        }

        private static void DotNetGc()
        {
            GC.Collect();
            GC.WaitForPendingFinalizers();
        }


    }
}


