#include "stdio.h"
/*
  插入排序：将一个元素插入到一个已经排好序的序列中，使得序列依然有序。
*/

// 统计比较次数
int compare_count = 0;

// 从后往前查找第一个比v[n]小的元素，其后一个位置即为插入位置
int search(int v[], int n)
{
    int i;
    int tmp = v[n];
    for (i = n - 1; i >= 0; i--)
    {
        compare_count++; // 统计比较次数
        if (v[i] <= tmp)
            break;
    }
    return i + 1;
}

// 将新的元素插入到指定位置，并将后续元素后移
void insert(int *v, int k, int n)
{
    int i;
    int tmp = v[n];
    for (i = n - 1; i >= k; i--)
    {
        v[i + 1] = v[i];
    }
    v[k] = tmp;
}

void insertion_sort(int v[], int n)
{
    int i;
    for (i = 1; i < n; i++)
    { // 从第二个元素开始，依次插入到前面已经排好序的序列中
        int place = search(v, i);
        insert(v, place, i);
    }
}

int main()
{
    FILE *infile, *outfile;
    int buffer[1001];
    infile = fopen("a.in", "rb");
    fread(buffer, 4, 1001, infile);
    fclose(infile);
    int N = buffer[0];
    insertion_sort(&(buffer[1]), N);
    buffer[0] = compare_count;
    outfile = fopen("a.out", "wb");
    fwrite(buffer, 4, N + 1, outfile);
    fclose(outfile);
    return 0;
}
