import static org.junit.Assert.assertEquals;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;

import org.junit.Test;

public class NodeExporterContainerShould extends ContainerTestBase {
  @Test
  public void listenOnWebPort() throws IOException {
    URL root = new URL(String.format("http://%s:%d",
    getContainer().getContainerIpAddress(),
    getContainer().getMappedPort(9100)));

    HttpURLConnection connection = (HttpURLConnection)root.openConnection();
    connection.connect();

    assertEquals(200,  connection.getResponseCode());
  }
}