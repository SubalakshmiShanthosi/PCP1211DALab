public static class Reduce extends MapReduceBase ... {
public void reduce(Text key, Iterator<IntWritable> values,
OutputCollector<Text, IntWritable> output, ...) ... {
int sum = 0;
while (values.hasNext()) {
sum += values.next().get();
}
output.collect(key, new IntWritable(sum));
}
}
}
