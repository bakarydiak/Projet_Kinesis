import com.amazonaws.ClientConfiguration;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.regions.RegionUtils;
import com.amazonaws.services.kinesis.AmazonKinesis;
import com.amazonaws.services.kinesis.AmazonKinesisClient;
import com.amazonaws.services.kinesis.model.*;
import com.amazonaws.services.kinesis.model.Record;
import com.amazonaws.services.kinesisfirehose.AmazonKinesisFirehoseClient;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import io.github.cdimascio.dotenv.Dotenv;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.ByteBuffer;
import java.util.List;

import static java.lang.Thread.sleep;

public class Main {
    static Dotenv dotenv = Dotenv.load();
    static String streamName = dotenv.get("streamName");
    static String shardId = dotenv.get("shardId");
    static String shardIteratorType = dotenv.get("shardIteratorType");
    static String url = dotenv.get("url");
    private static AWSCredentials awsCredentials ;
    static AmazonKinesis amazonKinesis;

    public static void main(String[] args) throws Exception {

        awsCredentials = Credentials.getCredentialsProvider().getCredentials();
        amazonKinesis = new AmazonKinesisClient(awsCredentials, Main.getClientConfigWithUserAgent());
        long t= System.currentTimeMillis();
        long end = t+3600000;
        while(System.currentTimeMillis() < end) {
            try {

                putInFireHose(getDataOfStream(putDataInStream()));

// Put record into the DeliveryStream

                sleep(1000);
            } catch (IOException e) {
                e.printStackTrace();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }


    public static ClientConfiguration getClientConfigWithUserAgent() {
        final ClientConfiguration config = new ClientConfiguration();
        config.setUserAgentPrefix(ClientConfiguration.DEFAULT_USER_AGENT);

        return config;
    }

    public static PutRecordResult putDataInStream () throws Exception {

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(Main.url))
                .build();
        HttpResponse response = client.send(request, HttpResponse.BodyHandlers.ofString());
        CurrentWeather currentWeather = new Gson().fromJson(response.body().toString(), CurrentWeather.class);
        byte[] currentWeatherAsBytes = new ObjectMapper().writeValueAsBytes(currentWeather);
        AWSCredentials awsCredentials = Credentials.getCredentialsProvider().getCredentials();

        AmazonKinesis amazonKinesis = new AmazonKinesisClient(awsCredentials, Main.getClientConfigWithUserAgent());
        amazonKinesis.setRegion(RegionUtils.getRegion("us-east-1"));
        PutRecordRequest putRecordRequest = new PutRecordRequest();
        putRecordRequest.setStreamName(Main.streamName);
        putRecordRequest.setPartitionKey(String.format("meteo-server-%s", currentWeather));
        putRecordRequest.setData(ByteBuffer.wrap(currentWeatherAsBytes));
        PutRecordResult putRecordResult = amazonKinesis.putRecord(putRecordRequest);
        System.out.println(putRecordResult.getSequenceNumber());
        return putRecordResult;
    }

    public static String getDataOfStream(PutRecordResult putRecordResult){
        List<Record> records;
        String shardIterator;
        GetShardIteratorRequest getShardIteratorRequest = new GetShardIteratorRequest();
        getShardIteratorRequest.setStreamName(streamName);
        getShardIteratorRequest.setShardId(shardId);
        getShardIteratorRequest.setShardIteratorType(shardIteratorType);
        getShardIteratorRequest.setStartingSequenceNumber(putRecordResult.getSequenceNumber());


        GetShardIteratorResult getShardIteratorResult = amazonKinesis.getShardIterator(getShardIteratorRequest);
        shardIterator = getShardIteratorResult.getShardIterator();
        return shardIterator;
    }

    public static void putInFireHose(String shardIdIterator){
        GetRecordsRequest getRecordsRequest = new GetRecordsRequest();
        getRecordsRequest.setShardIterator(shardIdIterator);
        getRecordsRequest.setLimit(25);


        GetRecordsResult result = amazonKinesis.getRecords(getRecordsRequest);

        // Put the result into record list. The result can be empty.
        List<Record> records = result.getRecords();
        records.stream().forEach(record ->
                {
                    com.amazonaws.services.kinesisfirehose.model.PutRecordRequest  putRecordRequest2 = new com.amazonaws.services.kinesisfirehose.model.PutRecordRequest();
                    putRecordRequest2.setDeliveryStreamName("s3-destination-delivery-meteo");


                    String data = " " + "\n";

                    com.amazonaws.services.kinesisfirehose.model.Record record2 = new com.amazonaws.services.kinesisfirehose.model.Record().withData(record.getData());

                    putRecordRequest2.setRecord(record2);
                    AmazonKinesisFirehoseClient firehoseClient = new AmazonKinesisFirehoseClient();
                    firehoseClient.putRecord(putRecordRequest2);
                }
        );
    }
}
