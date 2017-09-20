package br.riter.exchangecurrency;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.ObjectMetadata;

import java.io.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Map;

public class MonthExchange implements RequestHandler<Map<String,Object>, String> {

    private static final String BUCKET_NAME = "arturo-exchange";

    private static void store(byte[] bytes, String fileName) {
        AmazonS3 amazonS3 = AmazonS3Client.builder().build();
        InputStream inputStream = new ByteArrayInputStream(bytes);

        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentType("TEXT_PLAIN");
        metadata.setContentLength(bytes.length);

        amazonS3.putObject(BUCKET_NAME, fileName, inputStream, metadata);
    }

    private static byte[] getBytesFromInputStream(InputStream is) throws IOException {
        try (ByteArrayOutputStream os = new ByteArrayOutputStream();) {
            byte[] buffer = new byte[0xFFFF];

            for (int len; (len = is.read(buffer)) != -1; )
                os.write(buffer, 0, len);

            os.flush();

            return os.toByteArray();
        }
    }

    @Override
    public String handleRequest(Map<String,Object> input, Context context) {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String formattedDate = dateFormat.format(date);

        ProcessBuilder pb = new ProcessBuilder(
                "curl",
                "-s",
                "http://api.fixer.io/" + formattedDate + "?symbols=EUR,USD");

        pb.directory(new File("/tmp"));
        pb.redirectErrorStream(true);
        try {
            Process p = pb.start();
            InputStream is = p.getInputStream();

            //store on s3
            String filename = "lambda_exchange"+formattedDate+".txt";
            store(getBytesFromInputStream(is), filename);
        } catch (IOException e) {
            return e.getMessage();
        }
        return "Ok";
    }
}
